import urllib.request
import json

api_key = "AIzaSyAFYASz7_mGNVb63Y5UQiZDgeZNZgVbW5g"
url = f"https://generativelanguage.googleapis.com/v1beta/models?key={api_key}"

try:
    req = urllib.request.Request(url)
    with urllib.request.urlopen(req) as response:
        data = json.loads(response.read().decode())
        models = [m['name'] for m in data.get('models', [])]
        print("Models:", models)
except Exception as e:
    print("Error:", e)
