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

# db/seeds.rb

ThemeMoodMessage.destroy_all
ThemeMood.destroy_all
MoodCategory.destroy_all
Mood.destroy_all

mood_excellent = Mood.create!(name: "Excelente")
mood_good      = Mood.create!(name: "Bom")
mood_neutral   = Mood.create!(name: "Neutro")
mood_bad       = Mood.create!(name: "Ruim")
mood_terrible  = Mood.create!(name: "Péssimo")

mood_category_gretchen = MoodCategory.create!(
  name:      "Gretchen",
  image_url: "https://www.dgitais.com/wp-content/uploads/2017/11/download-11.jpg",
  phrase:    "Tem que respeitar meus 37 anos de carreira!"
)

mood_category_nazare = MoodCategory.create!(
  name:      "Nazaré Tedesco",
  image_url: "https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fnazare.png?alt=media&token=02fac403-29ae-425e-9ce9-3cf63c7a312d",
  phrase:    "Incrível como o tempo só te valoriza!"
)

mood_category_shrek = MoodCategory.create!(
  name:      "Shrek",
  image_url: "https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fburro_shrek.png?alt=media&token=cc85e0e5-914d-4acb-8341-2aab4caebd36",
  phrase:    "Isso vai ser divertido. Vamos ficar acordados até tarde, trocando histórias de homem e pela manhã... te faço panquecas."
)

theme_mood_gretchen_excellent = ThemeMood.create!(
  mood_category: mood_category_gretchen,
  mood:          mood_excellent,
  image_url:     "https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fgretchen_excelente.jpg?alt=media&token=97cbc27e-7181-489b-a19d-209a32506d1b"
)

theme_mood_gretchen_good = ThemeMood.create!(
  mood_category: mood_category_gretchen,
  mood:          mood_good,
  image_url:     "https://midias.folhavitoria.com.br/files/2016/11/gretchen.jpg"
)

theme_mood_gretchen_neutral = ThemeMood.create!(
  mood_category: mood_category_gretchen,
  mood:          mood_neutral,
  image_url:     "https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fgretchen_neutra.jpg?alt=media&token=5d57062e-b86c-4d96-9b04-0b9a35575765"
)

theme_mood_gretchen_bad = ThemeMood.create!(
  mood_category: mood_category_gretchen,
  mood:          mood_bad,
  image_url:     "https://s2-techtudo.glbimg.com/u3J5vQSmvMGgoYRfI84cC9i5rrk=/400x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_08fbf48bc0524877943fe86e43087e7a/internal_photos/bs/2023/V/4/dd8DP1QxSP3bRuiDH1Zw/c43-lkfvyaaszuy.jpg"
)

theme_mood_gretchen_terrible = ThemeMood.create!(
  mood_category: mood_category_gretchen,
  mood:          mood_terrible,
  image_url:     "https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fgretchen_pessima.jpg?alt=media&token=eb2b7c09-08c0-4a1d-a574-035abc3090c8"
)

theme_mood_shrek_excellent = ThemeMood.create!(
  mood_category: mood_category_shrek,
  mood:          mood_excellent,
  image_url:     "https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fshrek_excelente.jpg?alt=media&token=34f3518d-7300-40bc-8f87-79bc5d9f41fe"
)

theme_mood_shrek_good = ThemeMood.create!(
  mood_category: mood_category_shrek,
  mood:          mood_good,
  image_url:     "https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fshrek_bom.jpg?alt=media&token=5aef7da4-64e7-4394-a37a-e9270abc1834"
)

theme_mood_shrek_neutral = ThemeMood.create!(
  mood_category: mood_category_shrek,
  mood:          mood_neutral,
  image_url:     "https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fburro_neutro.jpg?alt=media&token=a3482582-65bf-43f6-b7fa-47fb5e60c302"
)

theme_mood_shrek_bad = ThemeMood.create!(
  mood_category: mood_category_shrek,
  mood:          mood_bad,
  image_url:     "https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fburro_ruim.jpg?alt=media&token=b97b6729-f02c-4e08-be0a-7721be3cd4cd"
)

theme_mood_shrek_terrible = ThemeMood.create!(
  mood_category: mood_category_shrek,
  mood:          mood_terrible,
  image_url:     "https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fshrek_pessimo.jpg?alt=media&token=359ac798-cd58-43e8-aa20-e942ca7170ba"
)

theme_mood_nazare_excellent = ThemeMood.create!(
  mood_category: mood_category_nazare,
  mood:          mood_excellent,
  image_url:     "https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fnazare_excelente.jpg?alt=media&token=35387ca6-5691-48e5-993c-5af0c66ad867"
)

theme_mood_nazare_good = ThemeMood.create!(
  mood_category: mood_category_nazare,
  mood:          mood_good,
  image_url:     "https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fnazare_boa.jpg?alt=media&token=4a3a8121-ccee-44c5-ad40-d92bf1241656"
)

theme_mood_nazare_neutral = ThemeMood.create!(
  mood_category: mood_category_nazare,
  mood:          mood_neutral,
  image_url:     "https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fnazare_neutra.jpg?alt=media&token=dc4ec555-7c37-49ff-9f9c-3473c11248b0"
)

theme_mood_nazare_bad = ThemeMood.create!(
  mood_category: mood_category_nazare,
  mood:          mood_bad,
  image_url:     "https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fnazare_ruim.jpg?alt=media&token=904d4311-830f-4d54-8b76-8af088cae2f8"
)

theme_mood_nazare_terrible = ThemeMood.create!(
  mood_category: mood_category_nazare,
  mood:          mood_terrible,
  image_url:     "https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fnazare_pessima.jpg?alt=media&token=9feb615a-aa0b-4665-a3ce-8ee392b80fdd"
)

theme_mood_messages = [
  {
    theme_mood: theme_mood_gretchen_excellent,
    messages: [
      "Uau, que energia maravilhosa você está transmitindo hoje! Use essa vibração positiva para conquistar todas as suas tarefas com muito brilho e sucesso!",
      "Seu sorriso radiante está contagiando todo mundo! Aproveite essa disposição incrível para realizar tudo o que precisa com alegria e eficiência.",
      "Com esse humor tão alto, você pode transformar qualquer desafio em uma vitória! Vamos lá, dance com suas responsabilidades e brilhe ainda mais.",
      "Sua felicidade é inspiradora! Canalize essa energia para organizar seu dia e alcançar todos os seus objetivos com leveza.",
      "Que ótimo ver você tão animado! Use essa positividade para enfrentar as tarefas de hoje e fazer tudo acontecer de forma espetacular."
    ]
  },
  {
    theme_mood: theme_mood_gretchen_good,
    messages: [
      "Fico feliz em ver você de bom humor! Essa energia positiva vai te ajudar a enfrentar qualquer tarefa com mais facilidade e leveza.",
      "Aproveite esse sentimento bom para organizar suas atividades e fazer tudo com calma e eficiência. Você está indo muito bem!",
      "Seu bom humor é um grande aliado para um dia produtivo. Continue assim e veja como suas tarefas se tornam mais leves e agradáveis.",
      "Com esse humor bacana, nada é impossível! Use essa disposição para avançar nas suas responsabilidades e alcançar seus objetivos.",
      "Está de bom humor, então por que não transformar isso em produtividade? Vamos lá, você consegue realizar tudo que precisa hoje!"
    ]
  },
  {
    theme_mood: theme_mood_gretchen_neutral,
    messages: [
      "Mesmo com um humor mais neutro, você tem a força necessária para completar suas tarefas. Acredite no seu potencial!",
      "Dias neutros também são oportunidades para avançar. Mantenha o foco e organize-se para cumprir suas responsabilidades.",
      "Se o humor está mais calmo, aproveite para trabalhar de maneira tranquila e eficiente. Você está no controle!",
      "Mesmo sem muita energia, você pode dar pequenos passos e progredir nas suas atividades. Cada esforço conta!",
      "Mantenha-se firme, mesmo com um humor neutro. Você tem a capacidade de realizar suas tarefas com serenidade."
    ]
  },
  {
    theme_mood: theme_mood_gretchen_bad,
    messages: [
      "Nem sempre estamos no nosso melhor, e tudo bem. Foque no que é necessário e faça o seu melhor com o que tem.",
      "Aproveite esse momento mais tranquilo para se reorganizar e planejar suas próximas ações. Cada dia é uma nova chance.",
      "Um dia não tão bom pode ser um ótimo momento para refletir e buscar formas de melhorar. Foque nas pequenas vitórias!",
      "Mesmo que não esteja se sentindo no seu melhor, você pode ainda assim progredir. Dê um passo de cada vez.",
      "Está tudo certo em não estar se sentindo ótimo. Lembre-se de cuidar de si mesmo e buscar apoio se necessário."
    ]
  },
  {
    theme_mood: theme_mood_gretchen_terrible,
    messages: [
      "Hoje não está fácil, não é? Não hesite em pedir ajuda. Você não precisa enfrentar isso sozinho.",
      "Todos temos dias difíceis. Permita-se sentir e, se precisar, faça uma pausa para se recuperar.",
      "Hoje pode ser um desafio, mas lembre-se: você é forte e capaz de superar isso. Vá devagar e cuide-se.",
      "Ser péssimo em um dia não define quem você é. Foque nas pequenas coisas que podem te ajudar a melhorar.",
      "Quando tudo parece difícil, respire fundo e lembre-se de que cada dia é uma nova chance. Cuide de você."
    ]
  },
  {
    theme_mood: theme_mood_shrek_excellent,
    messages: [
      "Uau, que energia maravilhosa você está transmitindo hoje! Use essa vibração positiva para conquistar todas as suas tarefas com muito brilho e sucesso!",
      "Seu sorriso radiante está contagiando todo mundo! Aproveite essa disposição incrível para realizar tudo o que precisa com alegria e eficiência.",
      "Com esse humor tão alto, você pode transformar qualquer desafio em uma vitória! Vamos lá, dance com suas responsabilidades e brilhe ainda mais.",
      "Sua felicidade é inspiradora! Canalize essa energia para organizar seu dia e alcançar todos os seus objetivos com leveza.",
      "Que ótimo ver você tão animado! Use essa positividade para enfrentar as tarefas de hoje e fazer tudo acontecer de forma espetacular."
    ]
  },
  {
    theme_mood: theme_mood_shrek_good,
    messages: [
      "Fico feliz em ver você de bom humor! Essa energia positiva vai te ajudar a enfrentar qualquer tarefa com mais facilidade e leveza.",
      "Aproveite esse sentimento bom para organizar suas atividades e fazer tudo com calma e eficiência. Você está indo muito bem!",
      "Seu bom humor é um grande aliado para um dia produtivo. Continue assim e veja como suas tarefas se tornam mais leves e agradáveis.",
      "Com esse humor bacana, nada é impossível! Use essa disposição para avançar nas suas responsabilidades e alcançar seus objetivos.",
      "Está de bom humor, então por que não transformar isso em produtividade? Vamos lá, você consegue realizar tudo que precisa hoje!"
    ]
  },
]

theme_mood_messages.each do |data|
  data[:messages].each do |msg|
    ThemeMoodMessage.create!(
      theme_mood: data[:theme_mood],
      message:    msg
    )
  end
end

ThemeMoodMessage.create!(
  theme_mood: theme_mood_nazare_excellent,
  message:    "Vamos arrasar hoje! Comigo, você vai conseguir qualquer coisa, meu amor!"
)

ThemeMoodMessage.create!(
  theme_mood: theme_mood_nazare_good,
  message:    "Vamos dar o nosso melhor, porque comigo você não pode falhar! Eu sou sua mãe!"
)

ThemeMoodMessage.create!(
  theme_mood: theme_mood_nazare_neutral,
  message:    "Vem comigo que a NASA aqui óh, te leva lá pro espaço! Mas antes... faça suas tarefas!"
)

ThemeMoodMessage.create!(
  theme_mood: theme_mood_nazare_bad,
  message:    "Pelo amor de Deus, eu queria dormir! Mas a gente tem que trabalhááár!"
)

ThemeMoodMessage.create!(
  theme_mood: theme_mood_nazare_terrible,
  message:    "Não! Pelo amor de Deus, me deixa sair! Eu não posso ficar presa. Eu não nasci pra isso. Eu preciso sair, eu preciso ver gente, eu preciso bater perna!"
)
