import sys, os
sys.path.append(os.path.dirname(__file__))

basedir = os.path.abspath(os.path.dirname(__file__))

class Config(object):
    def __init__(self):
        self.SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'sqlite:///' + os.path.join(basedir, 'reweDB.db')
        self.SQLALCHEMY_TRACK_MODIFICATIONS = False
        self.JSONIFY_PRETTYPRINT_REGULAR = True
