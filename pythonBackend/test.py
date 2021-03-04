
from flaskApi import app, db
from flaskApi.models import User, Zipcode, Rewe, Product, Discount


for user in User.query.all():
    db.session.delete(user)

db.session.commit()#