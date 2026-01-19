from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/api/food')
def get_food():
    # Giả lập trả về danh sách món ăn
    return jsonify({
        "shop": "FoodHub Kitchen",
        "menu": ["Pizza Hai San", "Ga Ran KFC", "Tra Sua Full Topping", "Bun Bo Hue"],
        "status": "Ready"
    })

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)