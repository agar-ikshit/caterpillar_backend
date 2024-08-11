from fpdf import FPDF
import json

# Read JSON data from a file
with open('inspection_data.json', 'r') as file:
    data = json.load(file)

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

# General Information
general_info = {
    "Truck Serial Number": data['truckSerialNumber'],
    "Truck Model": data['truckModel'],
    "Inspection ID": data['inspectionID'],
    "Inspector Name": data['inspectorName'],
    "Inspection Employee ID": data['inspectionEmployeeID'],
    "Inspection Date & Time": data['inspectionDateTime'],
    "Inspection Location": data['inspectionLocation'],
    "Geo Coordinates": data['geoCoordinates'],
    "Service Meter Hours": data['serviceMeterHours'],
    "Inspector Signature": data['inspectorSignature'],
    "Customer Name": data['customerName'],
    "Customer ID": data['customerID']
}
pdf.set_font("Arial", size=12, style='B')
pdf.cell(0, 10, txt="General Information", ln=True)
pdf.set_font("Arial", size=10)
for key, value in general_info.items():
    pdf.cell(0, 10, txt=f"{key}: {value}", ln=True)
pdf.ln(10)

# Tires Section
tires_details = {
    "Tire Pressure": f"Left Front: {data['tires']['tirePressure']['leftFront']} PSI, Right Front: {data['tires']['tirePressure']['rightFront']} PSI, Left Rear: {data['tires']['tirePressure']['leftRear']} PSI, Right Rear: {data['tires']['tirePressure']['rightRear']} PSI",
    "Tire Condition": f"Left Front: {data['tires']['tireCondition']['leftFront']}, Right Front: {data['tires']['tireCondition']['rightFront']}, Left Rear: {data['tires']['tireCondition']['leftRear']}, Right Rear: {data['tires']['tireCondition']['rightRear']}",
    "Overall Tire Summary": data['tires']['overallTireSummary']
}
add_section(pdf, "Tires", tires_details, data['tires']['attachedImages'])

# Battery Section
battery_details = {
    "Battery Make": data['battery']['batteryMake'],
    "Battery Replacement Date": data['battery']['batteryReplacementDate'],
    "Battery Voltage": data['battery']['batteryVoltage'],
    "Battery Water Level": data['battery']['batteryWaterLevel'],
    "Battery Condition": data['battery']['batteryCondition'],
    "Battery Leak or Rust": data['battery']['batteryLeakOrRust'],
    "Battery Summary": data['battery']['batterySummary']
}
add_section(pdf, "Battery", battery_details, data['battery']['attachedImages'])

# Exterior Section
exterior_details = {
    "Rust/Dent/ Damage": data['exterior']['rustDentOrDamage'],
    "Oil Leak in Suspension": data['exterior']['oilLeakInSuspension'],
    "Exterior Summary": data['exterior']['exteriorSummary']
}
add_section(pdf, "Exterior", exterior_details, data['exterior']['attachedImages'])

# Brakes Section
brakes_details = {
    "Brake Fluid Level": data['brakes']['brakeFluidLevel'],
    "Brake Condition Front": data['brakes']['brakeConditionFront'],
    "Brake Condition Rear": data['brakes']['brakeConditionRear'],
    "Emergency Brake": data['brakes']['emergencyBrake'],
    "Brake Summary": data['brakes']['brakeSummary']
}
add_section(pdf, "Brakes", brakes_details, data['brakes']['attachedImages'])

# Engine Section
engine_details = {
    "Rust/Dent/Damage": data['engine']['rustDentOrDamage'],
    "Engine Oil Condition": data['engine']['engineOilCondition'],
    "Engine Oil Color": data['engine']['engineOilColor'],
    "Brake Fluid Condition": data['engine']['brakeFluidCondition'],
    "Brake Fluid Color": data['engine']['brakeFluidColor'],
    "Oil Leak in Engine": data['engine']['oilLeakInEngine'],
    "Engine Summary": data['engine']['engineSummary']
}
add_section(pdf, "Engine", engine_details, data['engine']['attachedImages'])

# Voice of Customer Section
customer_feedback_details = {
    "Customer Feedback": data['voiceOfCustomer']['customerFeedback']
}
add_section(pdf, "Voice of Customer", customer_feedback_details, data['voiceOfCustomer']['attachedImages'])

# Save the PDF
pdf.output("preliminary_vehicle_inspection_report_formatted.pdf")

print("Preliminary vehicle inspection report generated successfully!")
