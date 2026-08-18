from pages.login_page import LoginPage

base_url = "http://localhost:3000"

def test_login_exitoso(driver):
    login_page = LoginPage(driver, base_url)
    login_page.load()
    login_page.login("qatest@tallerweb.local", "QaTest123!")

    assert "dashboard" in driver.current_url or driver.find_elements(
        *login_page.dashboard_market
    )

def test_login_credenciales_invalidas(driver):
    login_page = LoginPage(driver, base_url)
    login_page.load()

    driver.find_element(*login_page.email_input).send_keys("qatest@tallerweb.local")
    driver.find_element(*login_page.password_input).send_keys("password_incorrecto")
    driver.find_element(*login_page.submit_button).click()

    # Ajustar para mostrar el error
    error_text = login_page.get_error_message()
    assert error_text