import os

import pytest
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.options import Options
from pages.login_page import LoginPage

base_url = "http://localhost:3000"
test_email = "qatest@tallerweb.local"
test_password = "QaTest123!"

@pytest.fixture
def driver():
    """Abre y cierra el navegador para cada test"""
    options = Options()
    if os.getenv("SELENIUM_HEADLESS") == "true":
        options.add_argument("--headless=new")
        options.add_argument("--no-sandbox")
        options.add_argument("--disable-dev-shm-usage")
    service = Service(ChromeDriverManager().install())
    d = webdriver.Chrome(service=service, options=options)
    d.implicitly_wait(5)
    yield d
    d.quit()

@pytest.fixture
def logged_in_driver(driver):
    """Devuelve un driver que ya inicio sesión, para test que no necesitan probar el login"""
    login_page = LoginPage(driver, base_url)
    login_page.load()
    login_page.login(test_email, test_password)
    return driver

