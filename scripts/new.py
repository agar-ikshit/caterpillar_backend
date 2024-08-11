from fpdf import FPDF

# Initialize PDF
pdf = FPDF()
pdf.set_auto_page_break(auto=True, margin=15)
pdf.add_page()

# Set Title
pdf.set_font("Arial", size=12, style='B')
pdf.cell(0, 10, "Caterpillar Inspection Report", ln=True, align='C')

# Add Truck Information
pdf.set_font("Arial", size=10, style='B')
pdf.ln(10)  # Line break
pdf.cell(0, 10, "Truck Information:", ln=True)
pdf.set_font("Arial", size=10)  # Reset font style
pdf.ln(2)
truck_info = [
    "Serial Number: 7301234",
    "Model: 730",
    "Inspection ID: 56748",
    "Inspector: Kabir",
    "Employee ID: EMP001",
    "Inspection Date & Time: August 10, 2024, 14:30",
    "Inspection Location: Warehouse A",
    "Customer: Acme Corp",
    "Customer ID: CUST12345"
]
for line in truck_info:
    pdf.cell(0, 10, line, ln=True)

# Add Geo-Coordinates
pdf.ln(10)
pdf.set_font("Arial", size=10, style='B')
pdf.cell(0, 10, "Geo-Coordinates:", ln=True)
pdf.set_font("Arial", size=10)  # Reset font style
pdf.ln(2)
geo_coords = [
    "Latitude: 40.7128",
    "Longitude: -74.0060"
]
for coord in geo_coords:
    pdf.cell(0, 10, coord, ln=True)

# Add Service Meter Hours
pdf.ln(10)
pdf.cell(0, 10, "Service Meter Hours: 15000", ln=True)

# Add Sections (Tires, Battery, Exterior, Brakes, Engine, Voice of Customer)
sections = {
    "Tire Inspection": [
        "Left Front: 32 PSI - Good",
        "Right Front: 30 PSI - Ok",
        "Left Rear: 32 PSI - Needs Replacement",
        "Right Rear: 30 PSI - Good",
        "Overall Summary: All tires are in good condition except the left rear which needs replacement.",
        "Attached Images: tire1.jpg, tire2.jpg, tire3.jpg, tire4.jpg"
    ],
    "Battery Inspection": [
        "Make: CAT",
        "Replacement Date: December 1, 2023",
        "Voltage: 12V",
        "Water Level: Good",
        "Condition: N",
        "Leak or Rust: N",
        "Summary: The battery is in good condition with no leaks or rust.",
        "Attached Images: battery1.jpg"
    ],
    "Exterior Inspection": [
        "Rust, Dent, or Damage: Y",
        "Oil Leak in Suspension: N",
        "Summary: Some minor rust and a small dent on the rear bumper.",
        "Attached Images: exterior1.jpg, exterior2.jpg"
    ],
    "Brakes Inspection": [
        "Fluid Level: Ok",
        "Front Condition: Good",
        "Rear Condition: Ok",
        "Emergency Brake: Good",
        "Summary: Brakes are in good condition overall.",
        "Attached Images: brakes1.jpg"
    ],
    "Engine Inspection": [
        "Model: Cat® C13",
        "Gross Power SAE J1995: 280 kW",
        "Net Power SAE J1349: 274 kW",
        "Bore: 130 mm",
        "Stroke: 157 mm",
        "Displacement: 12.51 L",
        "Net Power ISO14396: 276 kW",
        "Peak Torque Speed: 1200 r/min",
        "Peak Torque Gross SAE J1995: 2141 N·m",
        "Peak Torque Net SAE J1349: 2107 N·m",
        "No De-rating Required Below: 3810 m",
        "EPA Stage IV: U.S. EPA Tier 4 Final/EU Stage IV",
        "Summary: Engine is in good condition with no signs of rust or leaks.",
        "Attached Images: engine1.jpg"
    ],
    "Voice of Customer Feedback": [
        "Customer Feedback: The inspection was thorough and well documented.",
        "Attached Images: feedback1.jpg"
    ]
}

for section, items in sections.items():
    pdf.ln(10)
    pdf.set_font("Arial", size=10, style='B')
    pdf.cell(0, 10, f"{section}:", ln=True)
    pdf.set_font("Arial", size=10)  # Reset font style
    pdf.ln(2)
    for item in items:
        pdf.cell(0, 10, item, ln=True)

# Add Summary and Recommendations
pdf.ln(10)
pdf.set_font("Arial", size=10, style='B')
pdf.cell(0, 10, "Summary:", ln=True)
pdf.set_font("Arial", size=10)  # Reset font style
pdf.ln(2)
summary = [
    "Overall, the truck is in decent condition with some minor issues.",
    "The left rear tire needs replacement, and there is some rust and a dent on the exterior.",
    "However, the battery, brakes, and engine are all in good condition.",
    "The customer feedback was positive, indicating satisfaction with the inspection process."
]
for line in summary:
    pdf.cell(0, 10, line, ln=True)

pdf.ln(10)
pdf.set_font("Arial", size=10, style='B')
pdf.cell(0, 10, "Recommendations:", ln=True)
pdf.set_font("Arial", size=10)  # Reset font style
pdf.ln(2)
recommendations = [
    "Replace the left rear tire promptly to ensure optimal safety and performance.",
    "Address the minor rust and dent on the exterior to maintain the truck's appearance and prevent further damage.",
    "Continue regular maintenance checks on the battery, brakes, and engine to prolong their lifespan and ensure continued functionality."
]
for rec in recommendations:
    pdf.cell(0, 10, f"- {rec}", ln=True)

# Add Conclusion
pdf.ln(10)
pdf.set_font("Arial", size=10, style='B')
pdf.cell(0, 10, "Conclusion:", ln=True)
pdf.set_font("Arial", size=10)  # Reset font style
pdf.ln(2)
conclusion = "Despite a few minor issues, the overall condition of the truck is satisfactory. By addressing the identified issues promptly and maintaining regular inspections and maintenance, the truck can continue to operate efficiently for an extended period. Thank you"
