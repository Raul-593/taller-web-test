from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class LoginPage:
    """
    Ajustar los selectores, con el atributo real
    """

    def __init__(self, driver, base_url):
        self.driver = driver
        self.base_url = base_url

        # Ajustar según HTML
        self.email_input = (By.NAME, "email")
        self.password_input = (By.NAME, "password")
        self.submit_button = (By.CSS_SELECTOR, "[data-testid='login-submit']")
        # Elemento que solo aparecen cuando el login fue exitoso
        self.dashboard_market = (By.CSS_SELECTOR, "[data-testid='dashboard']")

    def load(self):
        self.driver.get(f"{self.base_url}/login")

    def login(self, email, password):
        self.driver.find_element(*self.email_input).send_keys(email)
        self.driver.find_element(*self.password_input).send_keys(password)
        self.driver.find_element(*self.submit_button).click()
        # Espera a que cargue el dashboard
        WebDriverWait(self.driver, 10).until(
            EC.presence_of_element_located(self.dashboard_market)
        )

    def get_error_message(self):
        """
        Util para el test de login fallido --- Selector al mensaje de error real
        """
        error_el = self.driver.find_element(By.CSS_SELECTOR, "[data-testid='login-error']")
        return error_el.text