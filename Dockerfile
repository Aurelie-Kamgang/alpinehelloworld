FROM python:3.12-alpine

WORKDIR /opt/webapp

# Dépendances Python (cache-friendly)
COPY webapp/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Code de l'app
COPY webapp/ .

# Utilisateur non-root
RUN adduser -D appuser && chown -R appuser:appuser /opt/webapp
USER appuser

# Fallback pour le local; Heroku fournit $PORT automatiquement
ENV PORT=5000

# Lancement
CMD gunicorn --bind 0.0.0.0:${PORT} wsgi
