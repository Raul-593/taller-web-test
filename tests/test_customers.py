from pages.customers_page import CustomersPage

base_url = "http://localhost:3000"

def test_cliente_de_prueba_existe(logged_in_driver):
    """ Verifica que los datos QA están cargados """
    customer_page = CustomersPage(logged_in_driver, base_url)
    customer_page.load()

    assert customer_page.customer_is_listed("QA TEST Cliente Uno")

def test_agregar_nuevo_cliente(logged_in_driver):
    customer_page = CustomersPage(logged_in_driver, base_url)
    customer_page.load()
    customer_page.open_new_customers_form()
    customer_page.fill_and_save("QA TEST Cliente Selenium", "0992345678")

    assert customer_page.customer_is_listed("QA TEST Cliente Selenium")