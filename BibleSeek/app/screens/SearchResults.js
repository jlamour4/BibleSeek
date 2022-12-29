// SearchResults.js
import React, { useState, useEffect } from "react";
import {
  StyleSheet,
  Text,
  SafeAreaView,
  ActivityIndicator,
} from "react-native";

import SearchBar from "../components/SearchBar";

const SearchResults = () => {
  const [searchPhrase, setSearchPhrase] = useState("");
  const [clicked, setClicked] = useState(false);
  const [fakeData, setFakeData] = useState();

  // get data from the fake api
  useEffect(() => {
    const getData = async () => {
      const apiResponse = await fetch(
        "https://bibleseek-3ade5-default-rtdb.firebaseio.com/topicsList.json"
      );
      const data = await apiResponse.json();
      setFakeData(data);
    };
    getData();
  }, [setSearchPhrase]);

  return (
    <SafeAreaView style={styles.root}>
      {!clicked && <Text style={styles.title}>Programming Languages</Text>}

      <SearchBar
        searchPhrase={searchPhrase}
        setSearchPhrase={setSearchPhrase}
        clicked={clicked}
        setClicked={setClicked}
      />
      {!fakeData ? (
        <ActivityIndicator size="large" />
      ) : (
        
        
      )}
    </SafeAreaView>
  );
};

export default SearchResults;

const styles = StyleSheet.create({
  root: {
    justifyContent: "center",
    alignItems: "center",
  },
  title: {
    width: "100%",
    marginTop: 20,
    fontSize: 25,
    fontWeight: "bold",
    marginLeft: "10%",
  },
});
