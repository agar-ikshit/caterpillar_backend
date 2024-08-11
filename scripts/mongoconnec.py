from fpdf import FPDF
import pymongo
from pymongo import MongoClient

# MongoDB connection details
mongo_uri = "mongodb+srv://ikshitagarwa:iGGLqQyJUA7jk4LO@cluster0.9vwjx.mongodb.net/caterpillar_backend?retryWrites=true&w=majority"
database_name = "caterpillar_hackathon"
collection_name = "caterpillar_backend"

# Connect to MongoDB
try:
    print("Connecting to MongoDB...")
    client = MongoClient(mongo_uri)
    db = client[database_name]
    collection = db[collection_name]
    print("Connected to MongoDB successfully.")
except Exception as e:
    print(f"Error connecting to MongoDB: {e}")
    exit(1)

# Initialize PDF
pdf = FPDF()
pdf.add_page()

# Set title
pdf.set_font("Arial", size=12)
pdf.cell(0, 10, txt="Preliminary Vehicle Inspection Report", ln=True, align='C')
pdf.ln(10)

# Function to add section with details
def add_section(pdf, title, details, images):
    pdf.set_font("Arial", size=12, style='B')
    pdf.cell(0, 10, txt=title, ln=True)
    pdf.set_font("Arial", size=10)
    for key, value in details.items():
        pdf.cell(0, 10, txt=f"{key}: {value}", ln=True)
    pdf.ln(5)
    for img in images:
        pdf.cell(0, 10, txt=f"Image: {img}", ln=True)
    pdf.ln(10)

# Fetch and process all documents from the collection
try:
    documents = collection.find()
    num_docs = 0
    for data in documents:
        num_docs += 1

        # Debugging: Print document ID and a preview of the data
        print(f"Processing document {num_docs} with ID: {data.get('_id')}")
        print("Preview of document data:")
        print(data)
        
        # General Information
        general_info = {
            "Truck Serial Number": data.get('truckSerialNumber', 'N/A'),
            "Truck Model": data.get('truckModel', 'N/A'),
            "Inspection ID": data.get('inspectionID', 'N/A'),
            "Inspector Name": data.get('inspectorName', 'N/A'),
            "Inspection Employee ID": data.get('inspectionEmployeeID', 'N/A'),
            "Inspection Date & Time": data.get('inspectionDateTime', 'N/A'),
            "Inspection Location": data.get('inspectionLocation', 'N/A'),
            "Geo Coordinates": data.get('geoCoordinates', 'N/A'),
            "Service Meter Hours": data.get('serviceMeterHours', 'N/A'),
            "Inspector Signature": data.get('inspectorSignature', 'N/A'),
            "Customer Name": data.get('customerName', 'N/A'),
            "Customer ID": data.get('customerID', 'N/A')
        }
        pdf.set_font("Arial", size=12, style='B')
        pdf.cell(0, 10, txt="General Information", ln=True)
        pdf.set_font("Arial", size=10)
        for key, value in general_info.items():
            pdf.cell(0, 10, txt=f"{key}: {value}", ln=True)
        pdf.ln(10)

        # Tires Section
        tires_details = {
            "Tire Pressure": f"Left Front: {data.get('tires', {}).get('tirePressure', {}).get('leftFront', 'N/A')} PSI, Right Front: {data.get('tires', {}).get('tirePressure', {}).get('rightFront', 'N/A')} PSI, Left Rear: {data.get('tires', {}).get('tirePressure', {}).get('leftRear', 'N/A')} PSI, Right Rear: {data.get('tires', {}).get('tirePressure', {}).get('rightRear', 'N/A')} PSI",
            "Tire Condition": f"Left Front: {data.get('tires', {}).get('tireCondition', {}).get('leftFront', 'N/A')}, Right Front: {data.get('tires', {}).get('tireCondition', {}).get('rightFront', 'N/A')}, Left Rear: {data.get('tires', {}).get('tireCondition', {}).get('leftRear', 'N/A')}, Right Rear: {data.get('tires', {}).get('tireCondition', {}).get('rightRear', 'N/A')}",
            "Overall Tire Summary": data.get('tires', {}).get('overallTireSummary', 'N/A')
        }
        add_section(pdf, "Tires", tires_details, data.get('tires', {}).get('attachedImages', []))

        # Battery Section
        battery_details = {
            "Battery Make": data.get('battery', {}).get('batteryMake', 'N/A'),
            "Battery Replacement Date": data.get('battery', {}).get('batteryReplacementDate', 'N/A'),
            "Battery Voltage": data.get('battery', {}).get('batteryVoltage', 'N/A'),
            "Battery Water Level": data.get('battery', {}).get('batteryWaterLevel', 'N/A'),
            "Battery Condition": data.get('battery', {}).get('batteryCondition', 'N/A'),
            "Battery Leak or Rust": data.get('battery', {}).get('batteryLeakOrRust', 'N/A'),
            "Battery Summary": data.get('battery', {}).get('batterySummary', 'N/A')
        }
        add_section(pdf, "Battery", battery_details, data.get('battery', {}).get('attachedImages', []))

        # Exterior Section
        exterior_details = {
            "Rust/Dent/ Damage": data.get('exterior', {}).get('rustDentOrDamage', 'N/A'),
            "Oil Leak in Suspension": data.get('exterior', {}).get('oilLeakInSuspension', 'N/A'),
            "Exterior Summary": data.get('exterior', {}).get('exteriorSummary', 'N/A')
        }
        add_section(pdf, "Exterior", exterior_details, data.get('exterior', {}).get('attachedImages', []))

        # Brakes Section
        brakes_details = {
            "Brake Fluid Level": data.get('brakes', {}).get('brakeFluidLevel', 'N/A'),
            "Brake Condition Front": data.get('brakes', {}).get('brakeConditionFront', 'N/A'),
            "Brake Condition Rear": data.get('brakes', {}).get('brakeConditionRear', 'N/A'),
            "Emergency Brake": data.get('brakes', {}).get('emergencyBrake', 'N/A'),
            "Brake Summary": data.get('brakes', {}).get('brakeSummary', 'N/A')
        }
        add_section(pdf, "Brakes", brakes_details, data.get('brakes', {}).get('attachedImages', []))

        # Engine Section
        engine_details = {
            "Rust/Dent/Damage": data.get('engine', {}).get('rustDentOrDamage', 'N/A'),
            "Engine Oil Condition": data.get('engine', {}).get('engineOilCondition', 'N/A'),
            "Engine Oil Color": data.get('engine', {}).get('engineOilColor', 'N/A'),
            "Brake Fluid Condition": data.get('engine', {}).get('brakeFluidCondition', 'N/A'),
            "Brake Fluid Color": data.get('engine', {}).get('brakeFluidColor', 'N/A'),
            "Oil Leak in Engine": data.get('engine', {}).get('oilLeakInEngine', 'N/A'),
            "Engine Summary": data.get('engine', {}).get('engineSummary', 'N/A')
        }
        add_section(pdf, "Engine", engine_details, data.get('engine', {}).get('attachedImages', []))

        # Voice of Customer Section
        customer_feedback_details = {
            "Customer Feedback": data.get('voiceOfCustomer', {}).get('customerFeedback', 'N/A')
        }
        add_section(pdf, "Voice of Customer", customer_feedback_details, data.get('voiceOfCustomer', {}).get('attachedImages', []))

        # Add a new page for each document
        pdf.add_page()

    print(f"Total documents processed: {num_docs}")

except Exception as e:
    print(f"Error retrieving or processing data: {e}")

# Save the PDF
pdf_output_path = "preliminary_vehicle_inspection_report_formatted.pdf"
pdf.output(pdf_output_path)
print(f"Preliminary vehicle inspection report generated successfully at {pdf_output_path}!")
