import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";

actor {
  type MealId = Nat;
  
  type NutritionInfo = {
    calories: Nat;
    protein: Nat;
    carbs: Nat;
    fat: Nat;
  };

  type Meal = {
    id: MealId;
    recipe: Text;
    description: Text;
    date: Time.Time;
    nutrition: NutritionInfo;
    category: Text;  // breakfast, lunch, dinner, snack
  };

  var meals = Buffer.Buffer<Meal>(0);

  public func addMeal(recipe: Text, description: Text, category: Text, 
    calories: Nat, protein: Nat, carbs: Nat, fat: Nat) : async MealId {
    let mealId = meals.size();
    
    let newMeal: Meal = {
      id = mealId;
      recipe = recipe;
      description = description;
      date = Time.now();
      nutrition = {
        calories = calories;
        protein = protein;
        carbs = carbs;
        fat = fat;
      };
      category = category;
    };
    meals.add(newMeal);
    mealId
  };

  public query func getMeal(id: MealId) : async ?Meal {
    if (id < meals.size()) {
      ?meals.get(id)
    } else {
      null
    };
  };

  public query func getAllMeals() : async [Meal] {
    Buffer.toArray(meals)
  };

  public query func getMealsByCategory(category: Text) : async [Meal] {
    let filtered = Buffer.Buffer<Meal>(0);
    for (meal in meals.vals()) {
      if (Text.equal(meal.category, category)) {
        filtered.add(meal);
      };
    };
    Buffer.toArray(filtered)
  };

  public func updateMeal(id: MealId, recipe: Text, description: Text, 
    category: Text, calories: Nat, protein: Nat, carbs: Nat, fat: Nat) : async Bool {
    if (id >= meals.size()) return false;
    let meal = meals.get(id);
    
    let updatedMeal: Meal = {
      id = id;
      recipe = recipe;
      description = description;
      date = meal.date;
      nutrition = {
        calories = calories;
        protein = protein;
        carbs = carbs;
        fat = fat;
      };
      category = category;
    };
    meals.put(id, updatedMeal);
    true
  };
};