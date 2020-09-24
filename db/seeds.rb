# coding: utf-8

User.create!(name: "管理者",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password",
             #affiliation: "管理人",
             uid: 1,
             admin: true)

#User.create!(name: "上長A",
             #email: "samplea@email.com",
             #password: "password",
             #password_confirmation: "password",
             #affiliation: "上長",
             #employee_number: 2,
             #uid: 2,
             #superior: true)
             
#User.create!(name: "上長B",
             #email: "sampleb@email.com",
             #password: "password",
             #password_confirmation: "password",
             #affiliation: "上長",
             #employee_number: 3,
             #uid: 3,
             #superior: true)

5.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               uid: n+1)
end
#admin,superiorは指定なければ、false
#uidはemployee_numberは、初期値はid番号、uniquness。
#n+1問題　#{n+1}のnは0から始まる