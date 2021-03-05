import sys, os
sys.path.append(os.path.dirname(__file__))

from flaskApi.config import Config

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate


app = Flask(__name__)
app.config.from_object(Config())
db = SQLAlchemy(app)
migrate = Migrate(app, db)

from flaskApi import routes, models