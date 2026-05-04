//
//  NutrientFactSheet.swift
//  Nutrients Defficiency Tracker
//
//  Created by Anthony Blazer on 5/3/26.
//


import Foundation

struct NutrientFactSheet {
    let name: String
    let biochemicalRole: String
    let solubilityType: SolubilityType
    let absorptionScience: String
    let highDensityFoods: [FoodSource]
    let medicalLink: String
    let synergy: String
    let interference: String
    
    enum SolubilityType: String {
        case water = "Water-Soluble"
        case fat = "Fat-Soluble"
        case mineral = "Metallic Mineral"
    }
    
    struct FoodSource: Identifiable {
        let id = UUID()
        let name: String
        let category: String // e.g., "Animal-based (Heme)", "Plant-based"
    }
}


struct NutrientRegistry {
    static let data: [String: NutrientFactSheet] = [
        "Iron": NutrientFactSheet(
            name: "Iron",
            biochemicalRole: "Helps your red blood cells carry oxygen from your lungs to the rest of your body. It’s the key to maintaining your daily energy levels.",
            solubilityType: .mineral,
            absorptionScience: "Iron from meat is easier for your body to use. If you eat plant-based iron, pair it with a squeeze of lemon or orange juice to boost uptake.",
            highDensityFoods: [
                .init(name: "Steak, liver, or oysters", category: "Meat & Seafood"),
                .init(name: "Lentils, beans, or spinach", category: "Plant-based")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/Iron-Consumer/",
            synergy: "Vitamin C (helps absorption)",
            interference: "Coffee, Tea, and high-calcium dairy (if eaten at the exact same time)"
        ),
        "Magnesium": NutrientFactSheet(
            name: "Magnesium",
            biochemicalRole: "The body's 'relaxer.' It helps your muscles move, keeps your heart rhythm steady, and supports a calm nervous system.",
            solubilityType: .mineral,
            absorptionScience: "Your body absorbs different forms of magnesium at different rates. It is best absorbed when taken in smaller amounts throughout the day.",
            highDensityFoods: [
                .init(name: "Pumpkin seeds or almonds", category: "Nuts & Seeds"),
                .init(name: "Spinach or Swiss chard", category: "Leafy Greens"),
                .init(name: "Dark chocolate", category: "Treats")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/Magnesium-Consumer/",
            synergy: "Vitamin D3 and Vitamin B6",
            interference: "Too much supplemental Zinc or high-fiber 'phytic' foods"
        ),
        "Vitamin A": NutrientFactSheet(
            name: "Vitamin A",
            biochemicalRole: "Vital for sharp vision (especially in the dark), a strong immune system, and keeping your skin healthy.",
            solubilityType: .fat,
            absorptionScience: "Because it's fat-soluble, you should eat 'orange' veggies with a little healthy fat (like olive oil or avocado) to help your body absorb the nutrients.",
            highDensityFoods: [
                .init(name: "Beef liver or eggs", category: "Animal Sources"),
                .init(name: "Sweet potatoes or carrots", category: "Vegetables")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/VitaminA-Consumer/",
            synergy: "Healthy Fats and Zinc",
            interference: "Excessive alcohol consumption"
        ),
        "Vitamin D": NutrientFactSheet(
            name: "Vitamin D",
            biochemicalRole: "The 'Sunshine Vitamin.' It tells your body how to absorb calcium to keep your bones strong and supports your mood and immunity.",
            solubilityType: .fat,
            absorptionScience: "Your body makes this when sun hits your skin. In food, it must be eaten with some fat to be absorbed properly.",
            highDensityFoods: [
                .init(name: "Salmon or mackerel", category: "Seafood"),
                .init(name: "Milk or orange juice", category: "Fortified Drinks"),
                .init(name: "Egg yolks", category: "Animal Sources")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/VitaminD-Consumer/",
            synergy: "Calcium, Vitamin K2, and Magnesium",
            interference: "Certain weight-loss medications"
        ),
        "Vitamin B12": NutrientFactSheet(
            name: "Vitamin B12",
            biochemicalRole: "Essential for building DNA and keeping your brain and nerve cells firing correctly. It helps prevent a type of anemia that makes people feel tired.",
            solubilityType: .water,
            absorptionScience: "B12 absorption is a complex process in the stomach. As we get older, our bodies often need more help extracting it from food.",
            highDensityFoods: [
                .init(name: "Clams, trout, or salmon", category: "Seafood"),
                .init(name: "Beef, milk, or eggs", category: "Meat & Dairy"),
                .init(name: "Nutritional yeast", category: "Vegan Options")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/VitaminB12-Consumer/",
            synergy: "Folate (B9) and Vitamin B6",
            interference: "Heartburn medications and heavy alcohol use"
        ),
        "Vitamin C": NutrientFactSheet(
            name: "Vitamin C",
            biochemicalRole: "A powerful protector for your cells. It helps your body heal wounds, makes collagen for skin, and boosts your immune defense.",
            solubilityType: .water,
            absorptionScience: "Your body can't store this, so you need a fresh supply every day. Fun fact: smoking significantly lowers your body's levels.",
            highDensityFoods: [
                .init(name: "Oranges or lemons", category: "Citrus"),
                .init(name: "Strawberries or kiwi", category: "Fruit"),
                .init(name: "Bell peppers or broccoli", category: "Vegetables")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/VitaminC-Consumer/",
            synergy: "Iron (helps it absorb) and Vitamin E",
            interference: "Heat (cooking can destroy Vitamin C in vegetables)"
        ),
        "Calcium": NutrientFactSheet(
            name: "Calcium",
            biochemicalRole: "The building block for your bones and teeth. It also helps your muscles contract and your heart beat.",
            solubilityType: .mineral,
            absorptionScience: "Your body can only absorb about 500mg at a time. It's better to get calcium in small doses throughout the day rather than all at once.",
            highDensityFoods: [
                .init(name: "Yogurt, cheese, or milk", category: "Dairy"),
                .init(name: "Tofu or kale", category: "Plant-based"),
                .init(name: "Canned sardines", category: "Fish (with bones)")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/Calcium-Consumer/",
            synergy: "Vitamin D, Magnesium, and Vitamin K",
            interference: "Too much salt (sodium) or very high caffeine"
        ),
        "Potassium": NutrientFactSheet(
            name: "Potassium",
            biochemicalRole: "An essential mineral that balances the salt in your body. It keeps your blood pressure healthy and helps your muscles work.",
            solubilityType: .mineral,
            absorptionScience: "Potassium is found in almost all whole foods. It works in a delicate 'tug-of-war' balance with sodium.",
            highDensityFoods: [
                .init(name: "Potatoes or lentils", category: "Vegetables"),
                .init(name: "Bananas or apricots", category: "Fruit"),
                .init(name: "Yogurt", category: "Dairy")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/Potassium-Consumer/",
            synergy: "Sodium (keeping them in balance is key)",
            interference: "Certain blood pressure medications and licorice root"
        ),
        "Zinc": NutrientFactSheet(
            name: "Zinc",
            biochemicalRole: "Supports your immune system in fighting off bacteria and viruses. It’s also important for your sense of taste and smell.",
            solubilityType: .mineral,
            absorptionScience: "Zinc from meat is absorbed best. Grains and beans contain 'phytates' which can slow down how much zinc your body takes in.",
            highDensityFoods: [
                .init(name: "Oysters or crab", category: "Seafood"),
                .init(name: "Beef or pork", category: "Meat"),
                .init(name: "Pumpkin seeds", category: "Seeds")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/Zinc-Consumer/",
            synergy: "Protein (helps with absorption)",
            interference: "High doses of Iron or Copper supplements"
        ),
        "Folate": NutrientFactSheet(
            name: "Folate",
            biochemicalRole: "Helps your body make new cells and genetic material (DNA). It is especially important for hair, skin, and nail growth.",
            solubilityType: .water,
            absorptionScience: "Naturally found in food as 'Folate' and in supplements as 'Folic Acid.' Most people get plenty from fortified breads and grains.",
            highDensityFoods: [
                .init(name: "Spinach or asparagus", category: "Leafy Greens"),
                .init(name: "Lentils or chickpeas", category: "Legumes"),
                .init(name: "Avocado", category: "Fruit")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/Folate-Consumer/",
            synergy: "Vitamin B12",
            interference: "Alcohol and certain anti-inflammatory drugs"
        ),
        "Iodine": NutrientFactSheet(
            name: "Iodine",
            biochemicalRole: "Fuel for your thyroid gland. Your thyroid uses iodine to make hormones that control your metabolism and energy.",
            solubilityType: .mineral,
            absorptionScience: "Iodine is found mostly in the ocean and in soil. Most people get their daily dose from iodized table salt.",
            highDensityFoods: [
                .init(name: "Seaweed or Kelp", category: "Vegetables"),
                .init(name: "Cod or shrimp", category: "Seafood"),
                .init(name: "Iodized salt", category: "Pantry")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/Iodine-Consumer/",
            synergy: "Selenium",
            interference: "Eating massive amounts of raw 'cruciferous' veggies (like kale or cabbage)"
        ),
        "Vitamin E": NutrientFactSheet(
            name: "Vitamin E",
            biochemicalRole: "Acts as a shield for your cells, protecting them from damage. It also helps keep your immune system strong against viruses.",
            solubilityType: .fat,
            absorptionScience: "Found mostly in oily foods. Like other fat-soluble vitamins, it needs a little bit of fat in the meal to be absorbed.",
            highDensityFoods: [
                .init(name: "Sunflower seeds or almonds", category: "Nuts & Seeds"),
                .init(name: "Wheat germ oil", category: "Oils"),
                .init(name: "Spinach", category: "Vegetables")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/VitaminE-Consumer/",
            synergy: "Vitamin C and Selenium",
            interference: "Very high doses can interfere with Vitamin K and blood clotting"
        ),
        "Selenium": NutrientFactSheet(
            name: "Selenium",
            biochemicalRole: "A tiny but mighty mineral that protects your body from 'oxidative stress' (cell damage) and supports thyroid health.",
            solubilityType: .mineral,
            absorptionScience: "You only need a very small amount. Just one or two Brazil nuts a day is often enough to meet your entire goal!",
            highDensityFoods: [
                .init(name: "Brazil nuts", category: "Nuts"),
                .init(name: "Tuna or sardines", category: "Seafood"),
                .init(name: "Turkey or eggs", category: "Meat & Poultry")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/Selenium-Consumer/",
            synergy: "Vitamin E and Iodine",
            interference: "Taking too much in supplement form can be toxic"
        ),
        "Niacin": NutrientFactSheet(
            name: "Niacin",
            biochemicalRole: "Helps turn the food you eat into the energy you use. It also helps your nervous system and skin stay healthy.",
            solubilityType: .water,
            absorptionScience: "Your body can actually make a small amount of Niacin on its own if you eat enough protein.",
            highDensityFoods: [
                .init(name: "Chicken breast or beef", category: "Meat"),
                .init(name: "Tuna or salmon", category: "Fish"),
                .init(name: "Peanuts or brown rice", category: "Plant-based")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/Niacin-Consumer/",
            synergy: "Vitamin B6 and Iron",
            interference: "Very high doses can cause a 'flush' (temporary red, itchy skin)"
        ),
        "Copper": NutrientFactSheet(
            name: "Copper",
            biochemicalRole: "Works with iron to help the body form red blood cells. It also keeps your blood vessels, nerves, and immune system healthy.",
            solubilityType: .mineral,
            absorptionScience: "Copper is found in a wide variety of foods, so most people get enough through a balanced diet.",
            highDensityFoods: [
                .init(name: "Oysters or lobster", category: "Seafood"),
                .init(name: "Dark chocolate", category: "Treats"),
                .init(name: "Cashews or sunflower seeds", category: "Nuts & Seeds")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/Copper-Consumer/",
            synergy: "Iron",
            interference: "Too much Vitamin C or Zinc supplements can block copper"
        ),
        "Vitamin K": NutrientFactSheet(
            name: "Vitamin K",
            biochemicalRole: "The 'Clotting Vitamin.' It helps your blood heal wounds correctly and works with Calcium to keep your bones dense and strong.",
            solubilityType: .fat,
            absorptionScience: "Found mostly in leafy greens. Since it's fat-soluble, eating your salad with a healthy dressing (oil and vinegar) helps you absorb it.",
            highDensityFoods: [
                .init(name: "Kale, spinach, or collards", category: "Leafy Greens"),
                .init(name: "Broccoli or Brussels sprouts", category: "Vegetables"),
                .init(name: "Natty (fermented soy)", category: "Fermented Foods")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/VitaminK-Consumer/",
            synergy: "Vitamin D and Calcium",
            interference: "Blood-thinning medications (like Warfarin)"
        ),

        "Pantothenic Acid": NutrientFactSheet(
            name: "Pantothenic Acid",
            biochemicalRole: "Also known as Vitamin B5, it helps your body break down fats and carbohydrates to create a steady stream of energy.",
            solubilityType: .water,
            absorptionScience: "Its name comes from the Greek word 'pantothen,' meaning 'from everywhere,' because it is found in almost all plant and animal foods.",
            highDensityFoods: [
                .init(name: "Beef, chicken, or liver", category: "Meat"),
                .init(name: "Avocado", category: "Fruit"),
                .init(name: "Sunflower seeds or mushrooms", category: "Plant-based")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/PantothenicAcid-Consumer/",
            synergy: "Other B-Vitamins",
            interference: "High-heat cooking can reduce the amount in food"
        ),

        "Manganese": NutrientFactSheet(
            name: "Manganese",
            biochemicalRole: "Supports the health of your connective tissues and bones. It also plays a role in helping your blood clot and protecting cells from stress.",
            solubilityType: .mineral,
            absorptionScience: "Your body only needs a tiny amount. It is absorbed in the intestines and stored mostly in your bones, liver, and kidneys.",
            highDensityFoods: [
                .init(name: "Hazelnuts or pecans", category: "Nuts"),
                .init(name: "Oats, brown rice, or quinoa", category: "Whole Grains"),
                .init(name: "Chickpeas or lentils", category: "Legumes")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/Manganese-Consumer/",
            synergy: "Vitamin C and Vitamin E",
            interference: "Very high doses of Iron or Calcium can compete for absorption"
        ),
        "Phosphorus": NutrientFactSheet(
            name: "Phosphorus",
            biochemicalRole: "The second most abundant mineral in your body. It works with Calcium to build strong bones and helps your body store and use energy.",
            solubilityType: .mineral,
            absorptionScience: "It is found in almost all foods, but your body absorbs the phosphorus found in animal products much more efficiently than from plants.",
            highDensityFoods: [
                .init(name: "Milk, yogurt, or cheese", category: "Dairy"),
                .init(name: "Salmon or halibut", category: "Seafood"),
                .init(name: "Pumpkin seeds", category: "Seeds")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/Phosphorus-Consumer/",
            synergy: "Vitamin D and Calcium",
            interference: "Overusing antacids that contain aluminum"
        ),
        "Biotin": NutrientFactSheet(
            name: "Biotin",
            biochemicalRole: "Often called the 'Beauty B-Vitamin' because it supports the production of keratin, which keeps your hair, skin, and nails strong.",
            solubilityType: .water,
            absorptionScience: "Most people get plenty from a normal diet. Fun fact: Raw egg whites contain a protein that can block biotin absorption, but cooking the eggs fixes it!",
            highDensityFoods: [
                .init(name: "Cooked eggs (specifically the yolk)", category: "Dairy"),
                .init(name: "Salmon", category: "Seafood"),
                .init(name: "Sunflower seeds or sweet potatoes", category: "Plant-based")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/Biotin-Consumer/",
            synergy: "Other B-Vitamins",
            interference: "Long-term use of certain anti-seizure medications"
        ),

        "Chromium": NutrientFactSheet(
            name: "Chromium",
            biochemicalRole: "Helps your body move blood sugar (glucose) into your cells to be used for energy by improving how your body responds to insulin.",
            solubilityType: .mineral,
            absorptionScience: "Vitamin C and Niacin can help your body absorb chromium better, while high-sugar diets can actually cause your body to lose it faster.",
            highDensityFoods: [
                .init(name: "Broccoli", category: "Vegetables"),
                .init(name: "Grape juice", category: "Fruit"),
                .init(name: "Beef or turkey", category: "Meat")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/Chromium-Consumer/",
            synergy: "Vitamin C and Vitamin B3 (Niacin)",
            interference: "High-sugar diets and certain antacids"
        ),
        "Thiamin": NutrientFactSheet(
            name: "Thiamin",
            biochemicalRole: "Also known as Vitamin B1, it helps your body turn carbohydrates into energy and is essential for a healthy heart and nervous system.",
            solubilityType: .water,
            absorptionScience: "Your body doesn't store much of this, so you need a steady daily supply. It is easily lost in cooking water, so steaming is better than boiling.",
            highDensityFoods: [
                .init(name: "Pork or trout", category: "Meat & Fish"),
                .init(name: "Black beans or sunflower seeds", category: "Plant-based"),
                .init(name: "Fortified cereals", category: "Pantry")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/Thiamin-Consumer/",
            synergy: "Magnesium",
            interference: "Alcohol and tannins (found in tea and coffee)"
        ),

        "Riboflavin": NutrientFactSheet(
            name: "Riboflavin",
            biochemicalRole: "Known as Vitamin B2, it works to break down proteins, fats, and carbs. It’s also vital for maintaining healthy skin and eyes.",
            solubilityType: .water,
            absorptionScience: "Riboflavin is very sensitive to light. This is why milk is often sold in opaque containers—to protect the vitamin from being destroyed.",
            highDensityFoods: [
                .init(name: "Beef liver or eggs", category: "Meat"),
                .init(name: "Milk, yogurt, or cheese", category: "Dairy"),
                .init(name: "Almonds or spinach", category: "Plant-based")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/Riboflavin-Consumer/",
            synergy: "Iron and Vitamin B6",
            interference: "Excessive UV light exposure and alcohol"
        ),
        "Vitamin B6": NutrientFactSheet(
            name: "Vitamin B6",
            biochemicalRole: "Coenzyme for over 100 enzymes, mostly involved in protein and neurotransmitter metabolism.",
            solubilityType: .water,
            absorptionScience: "Absorbed by passive diffusion in the jejunum. Pyridoxine is the most stable form.",
            highDensityFoods: [
                .init(name: "Fish", category: "Salmon, tuna"),
                .init(name: "Starch", category: "Potatoes, starchy vegetables"),
                .init(name: "Fruit", category: "Bananas, chickpeas")
            ],
            medicalLink: "https://ods.od.nih.gov/factsheets/VitaminB6-HealthProfessional/",
            synergy: "Magnesium, Vitamin B12",
            interference: "Alcohol, Isoniazid"
        ),
    ]
}
