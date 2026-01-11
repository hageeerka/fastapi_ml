FROM python:3.11-slim
WORKDIR /app

RUN pip install --no-cache-dir -U pip setuptools wheel
RUN pip install --no-cache-dir poetry

COPY pyproject.toml poetry.lock* ./
RUN poetry config virtualenvs.create false \
    && poetry install --no-root --no-interaction --no-ansi

RUN pip install --no-cache-dir "packaging==24.2"

COPY . .
EXPOSE 8000
CMD ["uvicorn", "fastapi_skeleton.main:app", "--host", "0.0.0.0", "--port", "8000"]
