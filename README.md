# ProjectWords 

ProjectWords — это простое приложение, разработанное с использованием UIKit, которое демонстрирует навыки разработки мобильных приложений. Приложение позволяет пользователям с удобством изучать новые слова и термины и повторять их. Для этого они могут заводить карточки со словами, их переводом (значением) и транскрипцией, группировать слова по группам, проводить ревью изучаемых слов и отмечать уже изученные слова.


## 📌 Основные особенности
- Архитектура: **MVC**
- Используемые технологии: **UIKit, Storyboards, Realm (CRUD), UIStoryboardSegue, UITableView (UITableViewDelegate, UITableViewDataSource, UIContextualAction), UIView.animate, CASpringAnimation, UIAlertController**


## 📋 Краткое описание основных функций приложения
- Первый экран состоит из групп слов в виде таблицы UITableView и ее ячеек. Через UIAlertController можно редактировать существующие группы/добавлять новые. Можно также удалять группы, отмечать группу как изученную, видеть колличество неизученных слов внутри группы и делать сортировку групп слов по дате создания и по алфавитному порядку.
- Второй экран - погружение внутрь гуппы слов, здесь мы видим изучаемые слова в двух категориях: изучаемые и изученные. Через UIAlertController мы можем редактировать уже созданные слова/добавлять новые. Также слова можно удалять, отмечать как изученные. Можно нажать на кнопку Review и приступить к повторению слов.
- Третий экран это Review изучаемых слов. Здесь у нас карточки со словами, выдающие изучаемые слова в рандомном порядке. Карточки можно листать, можно переворачивать, чтобы подсмотреть перевод (значение) и транскрипцию изучаемого слова.
- У ячеек проработаны дейстия через свайп в бок UIContextualAction. 
- Realm отвечает за хранение слов и групп. 
- Также содан файл DataManager, который отвечает за первоначальную наполненность приложения словами и группами после установки приложения, чтобы помочь пользователю разобраться с функционалом. 


## 🎥 Записи экрана
![Groups](https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExcjdkNDQ3bXQwZmg5em1xMTJ6c2FyOWZscTE2eTd6Ynd0Y2w3eDA0YSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/PPL8pOMHdVq9VcMDhf/giphy.gif)
![Words](https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExeXJjNTJqb3drZmdhMzc4NXcwZDBvN2M1dDl3Ym8wZjZ5MXhnd2N2eCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/7HGKg8vltnX3XInFyB/giphy.gif)
![Review](https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExcHM3cGV4d21wbTVvMXBsbjJmZG1nM2F0Ymg3NWttbmJxNHNucWlhaCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/2wVEGHWC2FqrDMMDtx/giphy.gif)


## 🌳 Структура проекта
```bash
ProjectWords/
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── Info.plist
├── Controllers/
│   ├── WordGroupsViewController.swift
│   ├── WordsViewController.swift
│   └── ReviewViewController.swift
├── Models/
│   └── WordGroup.swift
├── Services/
│   ├── StorageManeger.swift
│   └── DataManager.swift
├── Extensions/
│   ├── Extension + UITableViewCell.swift
│   ├── Extension + UIAlertController.swift
│   └── Extension + UIButton.swift
├── Storyboards/
│   ├── Main.storyboard
│   └── LaunchScreen.storyboard
└── Resources/
   └── Assets.xcassets
```


## 💾 База данных Realm
![GroupsRealm](https://i.postimg.cc/mkTmf2Qh/temp-Image-MJQZy8.avif)
![WordsRealm](https://i.postimg.cc/LXtxbZgr/temp-Imageu2ae-Ob.avif)


## ⚙️ Установка
Для запуска приложения вам потребуется:
1. Установленный Xcode.
2. Клонировать репозиторий:

   ```bash
   git clone https://github.com/mokhinsam/ProjectWords.git
    ```
3. Открыть проект в Xcode:
    ```bash
    cd ProjectWords
    open ProjectWords.xcodeproj
    ```
4. Запустить приложение на симуляторе или физическом устройстве.


## 📫 Контакты
Если у вас есть вопросы или предложения, вы можете связаться со мной по электронной почте: mokhinsam@gmail.com
