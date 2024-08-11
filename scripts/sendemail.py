import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
from pymongo import MongoClient
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from reportlab.lib.units import inch
from bson import ObjectId
from datetime import datetime

# MongoDB setup
mongo_uri = "mongodb+srv://ikshitagarwa:iGGLqQyJUA7jk4LO@cluster0.9vwjx.mongodb.net/caterpillar_backend?retryWrites=true&w=majority"
client = MongoClient(mongo_uri)
database_name = "caterpillar_hackathon"
db = client[database_name]
collection_name = "caterpillar_backend"
collection = db[collection_name]
report_data = collection.find_one({}, sort=[('_id', -1)])

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

# Email setup
def send_email(pdf_filename, recipient_email):
    sender_email = "prakhar.agracode@gmail.com"  # Replace with your email address
    sender_password = "oznk jnuv ista wati"  # Replace with your Gmail app password

    # Create email message
    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = recipient_email
    msg['Subject'] = "Caterpillar Inspection Report"

    # Attach the PDF
    with open(pdf_filename, "rb") as attachment:
        part = MIMEApplication(attachment.read(), Name=pdf_filename)
    part['Content-Disposition'] = f'attachment; filename="{pdf_filename}"'
    msg.attach(part)

    # Add a text body
    body = "Please find the attached inspection report."
    msg.attach(MIMEText(body, 'plain'))

    # Send the email
    smtp_server = 'smtp.gmail.com'
    smtp_port = 587
    with smtplib.SMTP(smtp_server, smtp_port) as server:
        server.starttls()
        server.login(sender_email, sender_password)
        server.send_message(msg)

# Create PDF
pdf_filename = "inspection_report.pdf"
create_pdf(pdf_filename, report_data)

# Send the email
recipient_email = "ikshitagarwa@gmail.com"  # Replace with the recipient's email address
send_email(pdf_filename, recipient_email)
