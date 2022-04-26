from django.http import HttpRequest
from django.test import TestCase
from django.urls import resolve


class HomePageTest(TestCase):
    def test_returns_root_page(self):
        response = self.client.get("/")

        self.assertEqual(response.status_code, 200)
