from django.shortcuts import render

def home_view(request):
    # Ustawienie sesji
    request.session['username'] = 'JohnDoe'

    # Pobieranie sesji
    username = request.session.get('username')

    return render(request, 'index.html', {'username': username})