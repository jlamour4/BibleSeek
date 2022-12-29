// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getFirestore } from "firebase/firestore";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyCKaXN7gjAOaCEiKJlx4VoarTt5noUdeWI",
  authDomain: "bibleseek-3ade5.firebaseapp.com",
  projectId: "bibleseek-3ade5",
  storageBucket: "bibleseek-3ade5.appspot.com",
  messagingSenderId: "580469799823",
  appId: "1:580469799823:web:736f766bcb2469c32de9fa",
  measurementId: "G-J9GQGBFQ0D"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);



// Initialize Firestore
export const db = getFirestore(app);