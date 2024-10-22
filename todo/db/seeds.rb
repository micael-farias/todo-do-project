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

# db/seeds.rb

# Criação das categorias
gretchen = MoodCategory.find_or_create_by!(name: "Gretchen")
shrek = MoodCategory.find_or_create_by!(name: "Shrek")

# Criação dos humores
excellent = Mood.find_or_create_by!(name: "Excelente")
good = Mood.find_or_create_by!(name: "Bom")
neutral = Mood.find_or_create_by!(name: "Neutro")
bad = Mood.find_or_create_by!(name: "Ruim")
terrible = Mood.find_or_create_by!(name: "Péssimo")

# Associações ThemeMood para Gretchen
gretchen_excellent = ThemeMood.find_or_create_by!(
  mood_category: gretchen,
  mood: excellent,
  image_url: "https://via.placeholder.com/50/FF0000/FFFFFF?text=Gretchen+Excelente",
  message: "Gretchen está excelente hoje!"
)

gretchen_good = ThemeMood.find_or_create_by!(
  mood_category: gretchen,
  mood: good,
  image_url: "https://via.placeholder.com/50/00FF00/FFFFFF?text=Gretchen+Bom",
  message: "Gretchen está se sentindo bem."
)

gretchen_neutral = ThemeMood.find_or_create_by!(
  mood_category: gretchen,
  mood: neutral,
  image_url: "https://via.placeholder.com/50/FFFF00/FFFFFF?text=Gretchen+Neutro",
  message: "Gretchen está neutra."
)

gretchen_bad = ThemeMood.find_or_create_by!(
  mood_category: gretchen,
  mood: bad,
  image_url: "https://via.placeholder.com/50/FFA500/FFFFFF?text=Gretchen+Ruim",
  message: "Gretchen não está se sentindo bem."
)

gretchen_terrible = ThemeMood.find_or_create_by!(
  mood_category: gretchen,
  mood: terrible,
  image_url: "https://via.placeholder.com/50/FF4500/FFFFFF?text=Gretchen+Péssimo",
  message: "Gretchen está péssima hoje!"
)

# Associações ThemeMood para Shrek
shrek_excellent = ThemeMood.find_or_create_by!(
  mood_category: shrek,
  mood: excellent,
  image_url: "https://via.placeholder.com/50/FF0000/FFFFFF?text=Shrek+Excelente",
  message: "Shrek está excelente hoje!"
)

shrek_good = ThemeMood.find_or_create_by!(
  mood_category: shrek,
  mood: good,
  image_url: "https://via.placeholder.com/50/00FF00/FFFFFF?text=Shrek+Bom",
  message: "Shrek está se sentindo bem."
)

shrek_neutral = ThemeMood.find_or_create_by!(
  mood_category: shrek,
  mood: neutral,
  image_url: "https://via.placeholder.com/50/FFFF00/FFFFFF?text=Shrek+Neutro",
  message: "Shrek está neutro."
)

shrek_bad = ThemeMood.find_or_create_by!(
  mood_category: shrek,
  mood: bad,
  image_url: "https://via.placeholder.com/50/FFA500/FFFFFF?text=Shrek+Ruim",
  message: "Shrek não está se sentindo bem."
)

shrek_terrible = ThemeMood.find_or_create_by!(
  mood_category: shrek,
  mood: terrible,
  image_url: "https://via.placeholder.com/50/FF4500/FFFFFF?text=Shrek+Péssimo",
  message: "Shrek está péssimo hoje!"
)

# Criação das mensagens de encorajamento para Gretchen

# Gretchen - Humor Excelente
ThemeMoodMessage.create!(theme_mood: gretchen_excellent, message: "Uau, que energia maravilhosa você está transmitindo hoje! Use essa vibração positiva para conquistar todas as suas tarefas com muito brilho e sucesso!")
ThemeMoodMessage.create!(theme_mood: gretchen_excellent, message: "Seu sorriso radiante está contagiando todo mundo! Aproveite essa disposição incrível para realizar tudo o que precisa com alegria e eficiência.")
ThemeMoodMessage.create!(theme_mood: gretchen_excellent, message: "Com esse humor tão alto, você pode transformar qualquer desafio em uma vitória! Vamos lá, dance com suas responsabilidades e brilhe ainda mais.")
ThemeMoodMessage.create!(theme_mood: gretchen_excellent, message: "Sua felicidade é inspiradora! Canalize essa energia para organizar seu dia e alcançar todos os seus objetivos com leveza.")
ThemeMoodMessage.create!(theme_mood: gretchen_excellent, message: "Que ótimo ver você tão animado! Use essa positividade para enfrentar as tarefas de hoje e fazer tudo acontecer de forma espetacular.")

# Gretchen - Humor Bom
ThemeMoodMessage.create!(theme_mood: gretchen_good, message: "Fico feliz em ver você de bom humor! Essa energia positiva vai te ajudar a enfrentar qualquer tarefa com mais facilidade e leveza.")
ThemeMoodMessage.create!(theme_mood: gretchen_good, message: "Aproveite esse sentimento bom para organizar suas atividades e fazer tudo com calma e eficiência. Você está indo muito bem!")
ThemeMoodMessage.create!(theme_mood: gretchen_good, message: "Seu bom humor é um grande aliado para um dia produtivo. Continue assim e veja como suas tarefas se tornam mais leves e agradáveis.")
ThemeMoodMessage.create!(theme_mood: gretchen_good, message: "Com esse humor bacana, nada é impossível! Use essa disposição para avançar nas suas responsabilidades e alcançar seus objetivos.")
ThemeMoodMessage.create!(theme_mood: gretchen_good, message: "Está de bom humor, então por que não transformar isso em produtividade? Vamos lá, você consegue realizar tudo que precisa hoje!")

# Gretchen - Humor Neutro
ThemeMoodMessage.create!(theme_mood: gretchen_neutral, message: "Mesmo com um humor mais neutro, você tem a força necessária para completar suas tarefas. Acredite no seu potencial!")
ThemeMoodMessage.create!(theme_mood: gretchen_neutral, message: "Dias neutros também são oportunidades para avançar. Mantenha o foco e organize-se para cumprir suas responsabilidades.")
ThemeMoodMessage.create!(theme_mood: gretchen_neutral, message: "Se o humor está mais calmo, aproveite para trabalhar de maneira tranquila e eficiente. Você está no controle!")
ThemeMoodMessage.create!(theme_mood: gretchen_neutral, message: "Mesmo sem muita energia, você pode dar pequenos passos e progredir nas suas atividades. Cada esforço conta!")
ThemeMoodMessage.create!(theme_mood: gretchen_neutral, message: "Mantenha-se firme, mesmo com um humor neutro. Você tem a capacidade de realizar suas tarefas com serenidade.")

# Gretchen - Humor Baixo
ThemeMoodMessage.create!(theme_mood: gretchen_bad, message: "Eu sei que hoje não é seu melhor dia, mas lembre-se que você é forte e pode superar qualquer desafio que surgir.")
ThemeMoodMessage.create!(theme_mood: gretchen_bad, message: "Mesmo com o humor baixo, tente dar pequenos passos para cumprir suas tarefas. Cada conquista conta e vai te levantar.")
ThemeMoodMessage.create!(theme_mood: gretchen_bad, message: "Quando o humor está em baixa, é importante cuidar de si. Mas também lembre-se que suas responsabilidades podem ajudar a distrair e te motivar.")
ThemeMoodMessage.create!(theme_mood: gretchen_bad, message: "Sei que não está fácil, mas você tem a determinação necessária para enfrentar as tarefas de hoje. Estou aqui torcendo por você!")
ThemeMoodMessage.create!(theme_mood: gretchen_bad, message: "Mesmo nos dias difíceis, você é capaz de realizar suas atividades. Dê um passo de cada vez e lembre-se do seu valor.")

# Gretchen - Humor Péssimo
ThemeMoodMessage.create!(theme_mood: gretchen_terrible, message: "Eu entendo que hoje está sendo muito difícil, mas saiba que você não está sozinho. Tente focar em uma tarefa de cada vez.")
ThemeMoodMessage.create!(theme_mood: gretchen_terrible, message: "Nos dias mais complicados, é importante ser gentil consigo mesmo. Se precisar, dê pausas e continue no seu próprio ritmo.")
ThemeMoodMessage.create!(theme_mood: gretchen_terrible, message: "Se o humor está realmente baixo, lembre-se de que é ok pedir ajuda e se apoiar em quem você confia para superar esse momento.")
ThemeMoodMessage.create!(theme_mood: gretchen_terrible, message: "Mesmo quando tudo parece pesado, tente encontrar uma pequena motivação para realizar algo hoje. Cada pequeno passo é uma vitória.")
ThemeMoodMessage.create!(theme_mood: gretchen_terrible, message: "Eu sinto muito que você esteja passando por isso. Tente se concentrar em tarefas simples e cuide de si enquanto avança devagar.")

# Criação das mensagens de encorajamento para Shrek

# Shrek - Humor Excelente
ThemeMoodMessage.create!(theme_mood: shrek_excellent, message: "Olha só você todo animado! Use essa energia toda pra arregaçar as mangas e mandar ver nas suas tarefas, não tem obstáculo que te segure!")
ThemeMoodMessage.create!(theme_mood: shrek_excellent, message: "Com esse humor lá em cima, você pode conquistar qualquer desafio. Bora lá, faça acontecer e mostre do que você é capaz!")
ThemeMoodMessage.create!(theme_mood: shrek_excellent, message: "Tá se sentindo ótimo? Então aproveite essa disposição pra organizar tudo e fazer um trabalho de primeira. Você arrasa!")
ThemeMoodMessage.create!(theme_mood: shrek_excellent, message: "Se o humor tá excelente, aproveita pra se dedicar de verdade e alcançar seus objetivos. Você tem tudo pra se sair bem!")
ThemeMoodMessage.create!(theme_mood: shrek_excellent, message: "A energia positiva que você tem hoje é perfeita pra realizar suas tarefas com sucesso. Vai em frente e faça acontecer!")

# Shrek - Humor Bom
ThemeMoodMessage.create!(theme_mood: shrek_good, message: "Tá de bom humor, então bora usar isso pra dar conta das tarefas. Com essa disposição, tudo fica mais fácil!")
ThemeMoodMessage.create!(theme_mood: shrek_good, message: "Aproveite esse clima bom pra se organizar e avançar nas suas responsabilidades. Você tá no caminho certo!")
ThemeMoodMessage.create!(theme_mood: shrek_good, message: "Com esse humor positivo, você consegue enfrentar qualquer desafio. Vamos lá, você consegue completar tudo!")
ThemeMoodMessage.create!(theme_mood: shrek_good, message: "Seu bom humor é o impulso que você precisa pra ser produtivo. Use essa energia pra fazer tudo o que precisa!")
ThemeMoodMessage.create!(theme_mood: shrek_good, message: "Tá se sentindo bem? Então use essa sensação pra trabalhar com mais leveza e eficiência. Você vai longe!")

# Shrek - Humor Neutro
ThemeMoodMessage.create!(theme_mood: shrek_neutral, message: "Mesmo com um humor mais neutro, você pode dar um bom passo nas suas tarefas. Fique tranquilo e foque no que precisa ser feito.")
ThemeMoodMessage.create!(theme_mood: shrek_neutral, message: "Dias calmos também são bons pra se organizar. Use esse momento pra planejar e avançar nas suas responsabilidades.")
ThemeMoodMessage.create!(theme_mood: shrek_neutral, message: "Se o humor está estável, aproveite pra manter o ritmo e completar suas tarefas com calma e eficiência.")
ThemeMoodMessage.create!(theme_mood: shrek_neutral, message: "Com um humor neutro, é possível trabalhar de forma equilibrada. Concentre-se e siga em frente!")
ThemeMoodMessage.create!(theme_mood: shrek_neutral, message: "Mesmo sem muita animação, você tem a capacidade de realizar suas tarefas. Mantenha o foco e tudo vai se ajeitando.")

# Shrek - Humor Baixo
ThemeMoodMessage.create!(theme_mood: shrek_bad, message: "Se o humor tá baixo, não se cobre demais. Dê um passo de cada vez e você vai conseguir cumprir suas tarefas.")
ThemeMoodMessage.create!(theme_mood: shrek_bad, message: "Eu sei que hoje tá difícil, mas tenta se organizar e fazer o que precisa. Você é mais forte do que imagina.")
ThemeMoodMessage.create!(theme_mood: shrek_bad, message: "Mesmo quando não tá fácil, você pode dar pequenas mãos pra completar o que precisa. Estou na torcida por você!")
ThemeMoodMessage.create!(theme_mood: shrek_bad, message: "Se o humor não tá lá, tenta focar nas tarefas essenciais e vai devagar. Cada esforço conta!")
ThemeMoodMessage.create!(theme_mood: shrek_bad, message: "Em dias mais pesados, é importante se cuidar. Mas também tente avançar nas suas responsabilidades no seu próprio ritmo.")

# Shrek - Humor Péssimo
ThemeMoodMessage.create!(theme_mood: shrek_terrible, message: "Se o humor tá péssimo, saiba que tá tudo bem em ter dias assim. Tente fazer pequenas tarefas e não se sobrecarregue.")
ThemeMoodMessage.create!(theme_mood: shrek_terrible, message: "Nos momentos difíceis, dê prioridade ao que é essencial. Não precisa fazer tudo de uma vez, vá devagar.")
ThemeMoodMessage.create!(theme_mood: shrek_terrible, message: "Eu entendo que hoje tá complicado. Tente focar no que realmente importa e peça ajuda se precisar.")
ThemeMoodMessage.create!(theme_mood: shrek_terrible, message: "Quando tudo parece pesado, é importante cuidar de si. Mas se puder, realize uma tarefa simples pra sentir um pouco de progresso.")
ThemeMoodMessage.create!(theme_mood: shrek_terrible, message: "Mesmo nos dias mais difíceis, você tem a força pra seguir em frente. Dê um passo de cada vez e cuide do seu bem-estar.")
