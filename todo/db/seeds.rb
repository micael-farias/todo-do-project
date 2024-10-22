# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Limpa dados existentes
Mood.destroy_all
MoodCategory.destroy_all
ThemeMood.destroy_all

# Criação das categorias
gretchen = MoodCategory.create!(name: "Gretchen")
shrek = MoodCategory.create!(name: "Shrek")

# Criação dos humores
excellent = Mood.create!(name: "Excelente")
good = Mood.create!(name: "Bom")
neutral = Mood.create!(name: "Neutro")
bad = Mood.create!(name: "Ruim")
terrible = Mood.create!(name: "Péssimo")

# Associações ThemeMood para Gretchen
ThemeMood.create!(mood_category: gretchen, mood: excellent, image_url: "https://via.placeholder.com/50/FF0000/FFFFFF?text=Gretchen+Excelente", message: "Gretchen está excelente hoje!")
ThemeMood.create!(mood_category: gretchen, mood: good, image_url: "https://via.placeholder.com/50/00FF00/FFFFFF?text=Gretchen+Bom", message: "Gretchen está se sentindo bem.")
ThemeMood.create!(mood_category: gretchen, mood: neutral, image_url: "https://via.placeholder.com/50/FFFF00/FFFFFF?text=Gretchen+Neutro", message: "Gretchen está neutra.")
ThemeMood.create!(mood_category: gretchen, mood: bad, image_url: "https://via.placeholder.com/50/FFA500/FFFFFF?text=Gretchen+Ruim", message: "Gretchen não está se sentindo bem.")
ThemeMood.create!(mood_category: gretchen, mood: terrible, image_url: "https://via.placeholder.com/50/FF4500/FFFFFF?text=Gretchen+Péssimo", message: "Gretchen está péssima hoje!")

# Associações ThemeMood para Shrek
ThemeMood.create!(mood_category: shrek, mood: excellent, image_url: "https://via.placeholder.com/50/FF0000/FFFFFF?text=Shrek+Excelente", message: "Shrek está excelente hoje!")
ThemeMood.create!(mood_category: shrek, mood: good, image_url: "https://via.placeholder.com/50/00FF00/FFFFFF?text=Shrek+Bom", message: "Shrek está se sentindo bem.")
ThemeMood.create!(mood_category: shrek, mood: neutral, image_url: "https://via.placeholder.com/50/FFFF00/FFFFFF?text=Shrek+Neutro", message: "Shrek está neutro.")
ThemeMood.create!(mood_category: shrek, mood: bad, image_url: "https://via.placeholder.com/50/FFA500/FFFFFF?text=Shrek+Ruim", message: "Shrek não está se sentindo bem.")
ThemeMood.create!(mood_category: shrek, mood: terrible, image_url: "https://via.placeholder.com/50/FF4500/FFFFFF?text=Shrek+Péssimo", message: "Shrek está péssimo hoje!")

