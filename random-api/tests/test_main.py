from fastapi.testclient import TestClient
from main import app

client = TestClient(app)


def test_get_random_valid() -> None:
    response = client.get("/random?min_nr=1&max_nr=10")
    assert response.status_code == 200
    data = response.json()
    assert "value" in data
    assert 1 <= data["value"] <= 10


def test_get_random_invalid() -> None:
    response = client.get("/random?min_nr=10&max_nr=1")
    assert response.status_code == 400
    assert response.json() == {"detail": "min_nr must be less than or equal to max_nr"}
