from django.contrib import admin
from django.urls import path, include
from .views import add_restaurant, edit_restaurant, get_restaurant_xml, get_restaurants_xml_by_id, get_restaurant_menu, restaurant, add_food, add_menu, menu_view, delete_menu, update_photo, edit_menu_category, edit_food, delete_food, restaurant_list, filter_restaurants

urlpatterns = [
        path("", restaurant_list, name="restaurant_list"),
        path("<int:id>", restaurant, name="restaurant"),
        path("add/", add_restaurant, name="add_restaurant"),
        path("<int:id>/menu/", get_restaurant_menu, name="get_restaurant_menu"),
        path("get/", get_restaurant_xml, name="get_restaurant_xml"),
        path("get/<int:id>/", get_restaurants_xml_by_id, name="get_restaurants_xml_by_id"),      
        path("add_food/", add_food, name="add_food"),
        path("add_menu/", add_menu, name="add_menu"),
        path("edit/<int:id>/", edit_restaurant, name="edit_restaurant"),
        path('restaurant/<int:restaurant_id>/menu/', menu_view, name='menu_view'),
        path('delete_menu/', delete_menu, name='delete_menu'),
        path('update_photo/', update_photo, name='update_photo'),
        path('edit_menu_category/', edit_menu_category, name='edit_menu_category'),
        path('edit_food/', edit_food, name='edit_food'),
        path('delete_food/', delete_food, name='delete_food'),
        path('filter/', filter_restaurants, name='filter_restaurants'),
]