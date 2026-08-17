from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class CustomersPage:
    """ Ajusta los selectores """
    def __init__(self, driver, base_url):
        self.driver = driver
        self.base_url = base_url

        # Selectores del Modal para agregar cliente
        self.add_button = (By.XPATH, "//button[contains(text(), 'Agregar Cliente')]")
        self.name_input = (By.ID, "name")
        self.phone_input = (By.ID, "phone")
        self.address_input = (By.ID, "address")
        self.save_button = (By.XPATH, "//button[@type='submit' and contains(text(), 'Guardar Cliente')]")

    # Redireccionar a la página correcta
    def load(self):
        self.driver.get(f"{self.base_url}/clientes")

    def wait_loaded(self):
        WebDriverWait(self.driver, 10).until(
            EC.presence_of_element_located((By.TAG_NAME, "table"))
        )
    def customer_is_listed(self, name: str) -> bool:
        self.wait_loaded()
        return name in self.driver.page_source

    def open_new_customers_form(self):
        self.driver.find_element(*self.add_button).click()
        # Esperar a que el modal esté realmente visible
        WebDriverWait(self.driver, 10).until(
            EC.visibility_of_element_located(self.name_input)
        )


    def fill_and_save(self, name: str, phone: str, address: str=""):
        self.driver.find_element(*self.name_input).send_keys(name)
        self.driver.find_element(*self.phone_input).send_keys(phone)
        if address:
            self.driver.find_element(*self.address_input).send_keys(address)
        self.driver.find_element(*self.save_button).click()
        # Espera a que el modal se cierre
        WebDriverWait(self.driver, 10).until(
            EC.invisibility_of_element_located(self.name_input)
        )