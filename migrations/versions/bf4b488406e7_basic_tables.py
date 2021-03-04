"""basic tables

Revision ID: bf4b488406e7
Revises: 
Create Date: 2021-03-04 12:25:29.731506

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'bf4b488406e7'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('product',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('name', sa.String(length=100), nullable=True),
    sa.Column('producer', sa.String(length=30), nullable=True),
    sa.Column('price', sa.Float(precision=2), nullable=True),
    sa.Column('on_sale', sa.Boolean(), nullable=True),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_product_name'), 'product', ['name'], unique=True)
    op.create_index(op.f('ix_product_price'), 'product', ['price'], unique=False)
    op.create_index(op.f('ix_product_producer'), 'product', ['producer'], unique=False)
    op.create_table('user',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('username', sa.String(length=64), nullable=True),
    sa.Column('plz', sa.String(length=5), nullable=True),
    sa.Column('email', sa.String(length=120), nullable=True),
    sa.Column('password_hash', sa.String(length=128), nullable=True),
    sa.Column('created_at', sa.DateTime(), nullable=True),
    sa.Column('is_admin', sa.Boolean(), nullable=True),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_user_created_at'), 'user', ['created_at'], unique=False)
    op.create_index(op.f('ix_user_email'), 'user', ['email'], unique=True)
    op.create_index(op.f('ix_user_plz'), 'user', ['plz'], unique=False)
    op.create_index(op.f('ix_user_username'), 'user', ['username'], unique=True)
    op.create_table('zipcode',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('district', sa.String(length=50), nullable=True),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('rewe',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('name', sa.String(length=64), nullable=True),
    sa.Column('adress', sa.String(length=100), nullable=True),
    sa.Column('plz', sa.Integer(), nullable=True),
    sa.ForeignKeyConstraint(['plz'], ['zipcode.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_rewe_adress'), 'rewe', ['adress'], unique=True)
    op.create_index(op.f('ix_rewe_name'), 'rewe', ['name'], unique=True)
    op.create_table('discount',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('rewe_id', sa.Integer(), nullable=True),
    sa.Column('product_id', sa.Integer(), nullable=True),
    sa.ForeignKeyConstraint(['product_id'], ['product.id'], ),
    sa.ForeignKeyConstraint(['rewe_id'], ['rewe.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('discount')
    op.drop_index(op.f('ix_rewe_name'), table_name='rewe')
    op.drop_index(op.f('ix_rewe_adress'), table_name='rewe')
    op.drop_table('rewe')
    op.drop_table('zipcode')
    op.drop_index(op.f('ix_user_username'), table_name='user')
    op.drop_index(op.f('ix_user_plz'), table_name='user')
    op.drop_index(op.f('ix_user_email'), table_name='user')
    op.drop_index(op.f('ix_user_created_at'), table_name='user')
    op.drop_table('user')
    op.drop_index(op.f('ix_product_producer'), table_name='product')
    op.drop_index(op.f('ix_product_price'), table_name='product')
    op.drop_index(op.f('ix_product_name'), table_name='product')
    op.drop_table('product')
    # ### end Alembic commands ###
