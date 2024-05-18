from django.conf import settings
from .models import Food

class Cart(object):
    def __init__(self, request):
        self.session = request.session
        cart = self.session.get(settings.CART_SESSION_ID)
        if not cart:
            cart = self.session[settings.CART_SESSION_ID] = {}
        self.cart = cart

    def add(self, product, quantity=1, overide_quantity=False):
        product_id = str(product.id)
        if product_id not in self.cart:
            self.cart[product_id] = {'quantity': 0, 'price': str(product.price)}
        if overide_quantity:
            self.cart[product_id]['quantity'] = quantity
        else:
            self.cart[product_id]['quantity'] += quantity
        self.save()

    def remove(self, product):
        product_id = str(product.id)
        if product_id in self.cart:
            del self.cart[product_id]
        self.save()

    def __iter__(self):
        food_ids = self.cart.keys()
        foods = Food.objects.filter(id__in=food_ids)
        cart = self.cart.copy()
        for food in foods:
            cart[str(food.id)]['food'] = food
        for item in cart.values():
            item['price'] = Decimal(item['price'])
            item['total_price'] = Decimal(item['price']) * item['quantity']
            yield item

    def __len__(self):
        return sum(item['quantity'] for item in self.cart.values())
    
    def get_sub_total_price(self):
        return sum(Decimal(item['price']) * item['quantity'] for item in self.cart.values())
    
    def clear(self):
        for key in list(self.cart.keys()):
            del self.cart[key]
        self.save()