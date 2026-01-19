from flask import Flask
import requests
import os

app = Flask(__name__)

# Mặc định kết nối localhost nếu chạy lẻ, sau này deploy sẽ đổi IP sau
BACKEND_URL = os.environ.get('BACKEND_URL', 'http://localhost:5000')

@app.route('/')
def index():
    try:
        # Gọi sang Backend lấy menu
        response = requests.get(f"{BACKEND_URL}/api/food", timeout=2)
        data = response.json()
        menu_items = "".join([f"<li>{mon}</li>" for mon in data['menu']])
        shop_name = data['shop']
        status_msg = "✅ Kết nối Backend thành công!"
        color = "green"
    except:
        shop_name = "FoodHub (Offline)"
        menu_items = "<li>Không tải được menu</li>"
        status_msg = "❌ Không kết nối được Backend"
        color = "red"

    return f"""
    <html>
    <body style="font-family: sans-serif; padding: 40px; text-align: center;">
        <h1>Chào mừng đến với {shop_name}</h1>
        <h3 style="color: {color};">{status_msg}</h3>
        <hr>
        <h3>Thực đơn hôm nay:</h3>
        <ul style="display: inline-block; text-align: left;">
            {menu_items}
        </ul>
        <p><i>Phiên bản: Microservices v1.0</i></p>
    </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5001)