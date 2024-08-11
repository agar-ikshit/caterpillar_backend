from pymongo import MongoClient
from bson.objectid import ObjectId
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Image
import pdfkit

# Connect to MongoDB
client = MongoClient('mongodb://localhost:27017/')
db = client['your_database']
collection = db['your_collection']

# Query the data
document = collection.find_one({"_id": ObjectId("66b844e807da7df336e5f65d")})

# Extract data from the document
data = document['inputData']['messages'][0]['content']

# Format the data
def format_report(data):
    formatted_report = f"""
    Caterpillar Inspection Report

    Truck Information:
    - Serial Number: {data['truckSerialNumber']}
    - Model: {data['truckModel']}
    - Inspection ID: {data['inspectionID']}
    - Inspector: {data['inspectorName']}
    - Employee ID: {data['inspectionEmployeeID']}
    - Inspection Date & Time: {data['inspectionDateTime']}
    - Inspection Location: {data['inspectionLocation']}
    - Customer: {data['customerName']}
    - Customer ID: {data['customerID']}

    Geo-Coordinates:
    - Latitude: {data['geoCoordinates'].split(',')[0]}
    - Longitude: {data['geoCoordinates'].split(',')[1]}

    Service Meter Hours: {data['serviceMeterHours']}

    ---
    Tire Inspection:
    - Left Front: {data['tires']['tirePressure']['leftFront']} PSI - {data['tires']['tireCondition']['leftFront']}
    - Right Front: {data['tires']['tirePressure']['rightFront']} PSI - {data['tires']['tireCondition']['rightFront']}
    - Left Rear: {data['tires']['tirePressure']['leftRear']} PSI - {data['tires']['tireCondition']['leftRear']}
    - Right Rear: {data['tires']['tirePressure']['rightRear']} PSI - {data['tires']['tireCondition']['rightRear']}
    - Overall Summary: {data['tires']['overallTireSummary']}

    Battery Inspection:
    - Make: {data['battery']['batteryMake']}
    - Replacement Date: {data['battery']['batteryReplacementDate']}
    - Voltage: {data['battery']['batteryVoltage']}
    - Water Level: {data['battery']['batteryWaterLevel']}
    - Condition: {data['battery']['batteryCondition']}
    - Leak or Rust: {data['battery']['batteryLeakOrRust']}
    - Summary: {data['battery']['batterySummary']}

    Exterior Inspection:
    - Rust, Dent, or Damage: {data['exterior']['rustDentOrDamage']}
    - Oil Leak in Suspension: {data['exterior']['oilLeakInSuspension']}
    - Summary: {data['exterior']['exteriorSummary']}

    Brakes Inspection:
    - Fluid Level: {data['brakes']['brakeFluidLevel']}
    - Front Condition: {data['brakes']['brakeConditionFront']}
    - Rear Condition: {data['brakes']['brakeConditionRear']}
    - Emergency Brake: {data['brakes']['emergencyBrake']}
    - Summary: {data['brakes']['brakeSummary']}

    Engine Inspection:
    - Model: {data['engine']['engineModel']}
    - Gross Power SAE J1995: {data['engine']['grossPowerSAEJ1995']}
    - Net Power SAE J1349: {data['engine']['netPowerSAEJ1349']}
    - Bore: {data['engine']['bore']}
    - Stroke: {data['engine']['stroke']}
    - Displacement: {data['engine']['displacement']}
    - Net Power ISO14396: {data['engine']['netPowerISO14396']}
    - Peak Torque Speed: {data['engine']['peakEngineTorqueSpeed']}
    - Peak Torque Gross SAE J1995: {data['engine']['peakEngineTorqueGrossSAEJ1995']}
    - Peak Torque Net SAE J1349: {data['engine']['peakEngineTorqueNetSAEJ1349']}
    - No De-rating Required Below: {data['engine']['noEngineDe-ratingRequiredBelow']}
    - EPA Stage IV: {data['engine']['engineModelEPAStageIV']}
    - Summary: {data['engine']['engineSummary']}

    Voice of Customer Feedback:
    - Customer Feedback: {data['voiceOfCustomer']['customerFeedback']}
    """

    return formatted_report

# Create PDF
def generate_pdf(text, filename):
    doc = SimpleDocTemplate(filename, pagesize=letter)
    styles = getSampleStyleSheet()
    content = []
    content.append(Paragraph(text, styles['Normal']))
    doc.build(content)

formatted_report = format_report(data)
generate_pdf(formatted_report, 'inspection_report.pdf')

print("PDF generated successfully.")
