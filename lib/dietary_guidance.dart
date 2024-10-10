import 'package:flutter/material.dart';

class DietaryGuideScreen extends StatelessWidget {
  final List<DietaryGuide> dietaryGuides = [
    DietaryGuide(
      title: "Introduction",
      content: "Proper nutrition is crucial for individuals with autism as it can impact their behavior, mood, and overall well-being. This guide aims to provide dietary recommendations and strategies to support healthy eating habits.",
    ),
    DietaryGuide(
      title: "General Dietary Recommendations",
      content: "- **Balanced Diet**: Include a variety of foods to ensure all nutritional needs are met.\n"
          "- **Hydration**: Encourage water consumption throughout the day.\n"
          "- **Mindful Eating**: Establish regular mealtime routines to foster a sense of security.",
    ),
    DietaryGuide(
      title: "Common Dietary Preferences and Restrictions",
      content: "### Gluten-Free\n"
          "Many individuals with autism may benefit from a gluten-free diet. Consider alternatives like rice, quinoa, and gluten-free grains.\n\n"
          "### Dairy-Free\n"
          "Dairy can cause digestive issues for some. Explore options like almond milk or coconut yogurt.",
    ),
    DietaryGuide(
      title: "Meal Planning",
      content: "### Sample Meal Plan\n"
          "- **Breakfast**: Oatmeal with berries and honey\n"
          "- **Lunch**: Grilled chicken salad with a variety of vegetables\n"
          "- **Dinner**: Quinoa with roasted vegetables\n"
          "- **Snacks**: Carrot sticks with hummus, apple slices with almond butter\n\n"
          "### Shopping List\n"
          "- Fruits: Apples, bananas, berries\n"
          "- Vegetables: Carrots, spinach, broccoli\n"
          "- Proteins: Chicken, beans, nuts",
    ),
    DietaryGuide(
      title: "Sensory Considerations",
      content: "Individuals may have preferences for certain textures. Experiment with various cooking methods to find what works best (e.g., roasting vs. steaming).",
    ),
    DietaryGuide(
      title: "Food Preparation Tips",
      content: "### Simple Recipe: Veggie Stir-Fry\n"
          "1. Chop your favorite vegetables.\n"
          "2. Heat a pan and add a splash of olive oil.\n"
          "3. Stir-fry the vegetables until tender. Season with salt and pepper.",
    ),
    DietaryGuide(
      title: "Behavioral Strategies",
      content: "Introduce new foods slowly, and pair them with familiar favorites to increase acceptance.",
    ),
    DietaryGuide(
      title: "Resources and References",
      content: "[Autism Speaks Nutrition Resources](https://www.autismspeaks.org/nutrition-resources)\n"
          "[The Autism Society](https://www.autism-society.org)",
    ),
    DietaryGuide(
      title: "Appendix",
      content: "Nutrient Guidelines Chart and Allergy Information Reference.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dietary Guidance', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: dietaryGuides.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: EdgeInsets.all(20),
              title: Text(
                dietaryGuides[index].title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              trailing: Icon(Icons.arrow_forward, color: Colors.teal),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(dietaryGuide: dietaryGuides[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final DietaryGuide dietaryGuide;

  DetailPage({required this.dietaryGuide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dietaryGuide.title, style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            dietaryGuide.content,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
      ),
    );
  }
}

class DietaryGuide {
  final String title;
  final String content;

  DietaryGuide({required this.title, required this.content});
}
