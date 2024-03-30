var ncp = require("node-clipboardy");
const axios = require("axios");
const FormData = require("form-data");
const fs = require("fs");

//Передаем адрес изображения при запуске скрипта в качестве параметра
// node imgbb.js "Путь к изображению"

const imagePath = process.argv[2];
//const imagePath = "C:\\ahk\\CustomLightShot\\test.jpg";

// Функция для загрузки фото на imgbb.com
async function uploadPhoto(apiKey, imagePath) {
  try {
    const formData = new FormData();
    formData.append("image", fs.createReadStream(imagePath));
    console.log(formData.getHeaders());
    const response = await axios.post(
      "https://api.imgbb.com/1/upload?key=" + apiKey,
      formData,
      {
        headers: {
          ...formData.getHeaders(),
        },
      }
    );

    return response.data;
  } catch (error) {
    console.error("Ошибка при загрузке фото:", error);
    throw error;
  }
}

// Замените 'YOUR_API_KEY' на ваш API-ключ от imgbb.com
//const apiKey = "407a655e96bc5e66bf18793c49bc29b1";
const apiKey = "e79707f88012799cf03d930ea3b6617e";
// Укажите путь к фотографии, которую хотите загрузить

// Загрузка фотографии и вывод результата
uploadPhoto(apiKey, imagePath)
  .then((result) => {
    console.log("Фото успешно загружено:", result.data.url);
    ncp.writeSync(result.data.url);
  })
  .catch((error) => {
    console.error("Произошла ошибка:", error);
  });
