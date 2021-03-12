from flaskApi import db
from datetime import datetime

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), index=True, unique=True)
    plz = db.Column(db.Integer, db.ForeignKey('zipcode.id'))
    email = db.Column(db.String(120), index=True, unique=True)
    password_hash = db.Column(db.String(128))
    created_at = db.Column(db.DateTime, index=True, default=datetime.utcnow)
    last_login_at = db.Column(db.DateTime) 
    is_admin = db.Column(db.Boolean, default=False)

    def __repr__(self):
        return '<User {}>'.format(self.username)

class Zipcode(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    district = db.Column(db.String(50), primary_key=True)

class Rewe(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64), index=True)
    adress = db.Column(db.String(100), index=True, unique=True)
    plz = db.Column(db.Integer, db.ForeignKey('zipcode.id'))

class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), index=True)
    price = db.Column(db.Float)
    img_src = db.Column(db.String(120))
    category = db.Column(db.String(30), index=True)
    rewe_plz = db.Column(db.Integer, db.ForeignKey('rewe.plz'))
    on_sale = db.Column(db.Boolean, index=True, default = False)