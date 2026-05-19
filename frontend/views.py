from decouple import config
from django.shortcuts import render


def basic(request, *args, **kwargs):
    onion = config("ONION_LOCATION", default="")
    context = {"ONION_LOCATION": onion}
    response = render(request, "frontend/basic.html", context=context)
    if onion:
        response["Onion-Location"] = f"http://{onion}"
    return response


def pro(request, *args, **kwargs):
    onion = config("ONION_LOCATION", default="")
    context = {"ONION_LOCATION": onion}
    response = render(request, "frontend/pro.html", context=context)
    if onion:
        response["Onion-Location"] = f"http://{onion}"
    return response