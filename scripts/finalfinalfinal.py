
from pymongo import MongoClient
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from reportlab.lib.units import inch
from bson import ObjectId  # Import ObjectId here
from datetime import datetime



mongo_uri = "mongodb+srv://ikshitagarwa:iGGLqQyJUA7jk4LO@cluster0.9vwjx.mongodb.net/caterpillar_backend?retryWrites=true&w=majority"

# Create a MongoClient instance
client = MongoClient(mongo_uri)

# Access the database
database_name = "caterpillar_hackathon"
db = client[database_name]

# Access the collection
collection_name = "caterpillar_backend"
collection = db[collection_name]
# Fetch the latest report (or a specific report based on criteria)
report_data = collection.find_one({}, sort=[('_id', -1)])  # Adjust query as needed

if not report_data:
    print("No report data found.")
    exit()

# Function to convert non-string values to string
def convert_to_string(value):
    if isinstance(value, dict):
        return "\n".join(f"{k}: {convert_to_string(v)}" for k, v in value.items())
    if isinstance(value, list):
        return "\n".join(str(item) for item in value)
    if isinstance(value, ObjectId):
        return str(value)
    if isinstance(value, datetime):
        return value.strftime('%Y-%m-%d %H:%M:%S')
    return str(value)

# Function to create a PDF
def create_pdf(filename, data):
    c = canvas.Canvas(filename, pagesize=letter)
    width, height = letter
    y_position = height - 1 * inch
    line_height = 14

    def draw_text(text, x, y):
        nonlocal y_position
        for line in text.split('\n'):
            c.drawString(x, y_position, line)
            y_position -= line_height
            if y_position < 1 * inch:
                c.showPage()
                y_position = height - 1 * inch

    # Title
    c.setFont("Helvetica-Bold", 16)
    draw_text("Caterpillar Inspection Report", 1 * inch, y_position)
    
    # Add data
    c.setFont("Helvetica", 12)
    for key, value in data.items():
        text = f"{key}: {convert_to_string(value)}"
        draw_text(text, 1 * inch, y_position)
    
    c.save()

# Create PDF
create_pdf("inspection_report.pdf", report_data)