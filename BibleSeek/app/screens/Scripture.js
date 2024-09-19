// Scripture.js
import { useNavigation } from "@react-navigation/native";
import DOMParser from 'react-native-html-parser';
import React, { useState, useEffect } from "react";
import {
  StyleSheet,
  Text,
  View,
  Image,
  SafeAreaView,
  ActivityIndicator,
	Pressable,
} from "react-native";

import MaterialCommunityIcons from 'react-native-vector-icons/MaterialCommunityIcons';


const Scripture = () => {
  const [searchPhrase, setSearchPhrase] = useState("");
  const [clicked, setClicked] = useState(false);
  const [fakeData, setFakeData] = useState();

	const navigation = useNavigation();

  // function httpGet(theUrl)
  // {
  //     if (window.XMLHttpRequest)
  //     {// code for IE7+, Firefox, Chrome, Opera, Safari
  //         xmlhttp=new XMLHttpRequest();
  //     }
  //     xmlhttp.onreadystatechange=function()
  //     {
  //         if (xmlhttp.readyState==4 && xmlhttp.status==200)w
  //         {
  //             return xmlhttp.responseText;
  //         }
  //     }
  //     xmlhttp.open("GET", theUrl, false );
  //     xmlhttp.send();    
  // }

  // get data from the fake api
  useEffect(() => {
    console.log("hello")
    const getData = async () => {
      const apiResponse = await fetch(
        "https://www.openbible.info/topics/?q=being+a+stepmom"
      );
      const data = await apiResponse.text();
      // console.log(data);
      setFakeData(data);
    };
    getData();
  }, []);


  function runFunction() {
    let doc = new DOMParser.DOMParser().parseFromString(fakeData, "text/html");
    console.log(doc);
    let verses = doc.querySelect(".verse");
    console.log(verses);
  }

  return (
    <SafeAreaView style={styles.root}>

    </SafeAreaView>
  );
};

export default Scripture;

const styles = StyleSheet.create({
	searchPlaceholderText: {
    fontSize: 18,
    color: global.darkGrey,
    width: "75%"
  },
  searchBarContainer: {
    borderRadius: 35,
    overflow: 'hidden',
    alignSelf: 'center',
    marginTop: 5,
    width: "86%"
  },
	searchBar: {
	flexDirection: "row",
	backgroundColor: global.offwhite,
    borderRadius: 35,
	height: 50,
    alignItems: "center",
	justifyContent: "space-between"
	},
  appLogo: {
    width: 130,
    height: 20,
    alignSelf: "center",
    marginTop: 25,
    marginBottom: 25
  },
  root: {
    justifyContent: "center",
    alignItems: "center",
  },
  header: {
    width: "100%",
	flexDirection: "column",
    backgroundColor: global.blue,
    color: 'white',
  },
  banner: {
    color: 'white',
    fontSize: 32,
    padding: 20,
    textAlignVertical: "center",
    textAlign: "center",
    fontFamily: "sans-serif-thin"
  },
  topicOfWeekSection: {
    backgroundColor: "white",
    width: "100%",
    padding: 20,
    borderBottomWidth: 1,
    borderBottomColor: global.offwhite
  },
  title: {
    width: "100%",
    marginTop: 20,
    fontSize: 25,
    fontWeight: "bold",
    marginLeft: "10%",
  },
});
