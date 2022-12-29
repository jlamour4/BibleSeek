// Search.js
import React, { useState, useEffect } from "react";
import {
  StyleSheet,
  Text,
  SafeAreaView,
  ActivityIndicator,
} from "react-native";

import TopicNameList from "../components/TopicNameList";
import TopicResultsList from "../components/TopicResultsList";
import SearchBar from "../components/SearchBar";
// import database from "@react-native-firebase/database"

// function getDatabaseReference(topicName) {
//   let reference = database().ref('/topics/' + topicName);
//   return reference;
// }r

const Search = () => {
  const [searchPhrase, setSearchPhrase] = useState("");
  const [clicked, setClicked] = useState(false);
  const [topicsList, setData] = useState();
  const [topicSelected, setSelectedTopic] = useState("");
  
  useEffect(() => {
    const getData = async () => {
      const apiResponse = await fetch(
        "https://bibleseek-3ade5-default-rtdb.firebaseio.com/topicsList.json"
      );
      const data = await apiResponse.json();
      setData(data);
    };
    getData();
  }, []);

  return (
    <SafeAreaView style={styles.root}>
      <SearchBar
        searchPhrase={searchPhrase}
        setSearchPhrase={setSearchPhrase}
        clicked={clicked}
        setClicked={setClicked}
        topicSelected={topicSelected}
        setSelectedTopic={setSelectedTopic}
      />
      {!topicsList ? (
        <ActivityIndicator size="large" style={styles.activityIndicator}/>
      ) : ( !topicSelected ? (
        <TopicNameList
            searchPhrase={searchPhrase}
            setSearchPhrase={setSearchPhrase}
            setSelectedTopic={setSelectedTopic}
            data={topicsList}
            setClicked={setClicked}
          />
      ) : (
        <TopicResultsList
          topicSelected={topicSelected}
        />
      )

      )}
    </SafeAreaView>
  );
};

export default Search;

const styles = StyleSheet.create({
  root: {
    // justifyContent: "center",
    alignItems: "center",
    flex: 1,
    backgroundColor: global.offwhite,
  },
  activityIndicator: {
    width: "100%",
    height: "auto",
    flexDirection: "row",
    transform: [{scaleX: 1.3}, {scaleY: 1.3}],
  }
});
