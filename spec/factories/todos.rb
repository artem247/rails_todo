FactoryBot.define do
  factory :todo do
    title { "MyString" }
    done { false }
    deadline { "2020-04-21 09:29:18" }
    todolist { nil }
  end
end
