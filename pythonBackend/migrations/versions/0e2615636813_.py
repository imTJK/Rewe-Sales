"""empty message

Revision ID: 0e2615636813
Revises: 
Create Date: 2021-03-08 21:47:26.129296

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '0e2615636813'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('zipcode',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('district', sa.String(length=50), nullable=False),
    sa.PrimaryKeyConstraint('id', 'district')
    )
    op.create_table('rewe',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('name', sa.String(length=64), nullable=True),
    sa.Column('adress', sa.String(length=100), nullable=True),
    sa.Column('plz', sa.Integer(), nullable=True),
    sa.ForeignKeyConstraint(['plz'], ['zipcode.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    with op.batch_alter_table('rewe', schema=None) as batch_op:
        batch_op.create_index(batch_op.f('ix_rewe_adress'), ['adress'], unique=True)
        batch_op.create_index(batch_op.f('ix_rewe_name'), ['name'], unique=False)

    op.create_table('user',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('username', sa.String(length=64), nullable=True),
    sa.Column('plz', sa.Integer(), nullable=True),
    sa.Column('email', sa.String(length=120), nullable=True),
    sa.Column('password_hash', sa.String(length=128), nullable=True),
    sa.Column('created_at', sa.DateTime(), nullable=True),
    sa.Column('is_admin', sa.Boolean(), nullable=True),
    sa.ForeignKeyConstraint(['plz'], ['zipcode.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    with op.batch_alter_table('user', schema=None) as batch_op:
        batch_op.create_index(batch_op.f('ix_user_created_at'), ['created_at'], unique=False)
        batch_op.create_index(batch_op.f('ix_user_email'), ['email'], unique=True)
        batch_op.create_index(batch_op.f('ix_user_username'), ['username'], unique=True)

    op.create_table('discount',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('rewe_id', sa.Integer(), nullable=True),
    sa.Column('product_id', sa.Integer(), nullable=True),
    sa.ForeignKeyConstraint(['product_id'], ['product.id'], ),
    sa.ForeignKeyConstraint(['rewe_id'], ['rewe.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('prices',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('product_id', sa.Integer(), nullable=True),
    sa.Column('rewe_plz', sa.Integer(), nullable=True),
    sa.Column('price', sa.String(length=10), nullable=True),
    sa.Column('on_sale', sa.Boolean(), nullable=True),
    sa.ForeignKeyConstraint(['product_id'], ['product.id'], ),
    sa.ForeignKeyConstraint(['rewe_plz'], ['rewe.plz'], ),
    sa.PrimaryKeyConstraint('id')
    )
    with op.batch_alter_table('prices', schema=None) as batch_op:
        batch_op.create_index(batch_op.f('ix_prices_price'), ['price'], unique=False)

    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('prices', schema=None) as batch_op:
        batch_op.drop_index(batch_op.f('ix_prices_price'))

    op.drop_table('prices')
    op.drop_table('discount')
    with op.batch_alter_table('user', schema=None) as batch_op:
        batch_op.drop_index(batch_op.f('ix_user_username'))
        batch_op.drop_index(batch_op.f('ix_user_email'))
        batch_op.drop_index(batch_op.f('ix_user_created_at'))

    op.drop_table('user')
    with op.batch_alter_table('rewe', schema=None) as batch_op:
        batch_op.drop_index(batch_op.f('ix_rewe_name'))
        batch_op.drop_index(batch_op.f('ix_rewe_adress'))

    op.drop_table('rewe')
    op.drop_table('zipcode')
    # ### end Alembic commands ###
