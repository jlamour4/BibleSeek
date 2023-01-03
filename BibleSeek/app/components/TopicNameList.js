import { getPathFromState, useNavigation } from "@react-navigation/native";
import React, { useEffect, useState } from "react";
import {
  StyleSheet,
  Text,
  View,
  FlatList,
  SafeAreaView,
  Pressable,
} from "react-native";

// definition of the Item, which will be rendered in the FlatList
const Item = ({ name }) => (
  <View style={styles.item}>
    <Text style={styles.title}>{name}</Text>
  </View>
);

const TopicNameList = (props) => {

  const navigation = useNavigation();
  const [filteredTopicsList, setFilteredTopicsList] = useState(props.searchPhrase);
  const [noData, setNoData] = useState(true);

  // Levenshtein Distance Algorithm
  function getEditDistance(a, b) {
    if (a.length === 0) return b.length; 
    if (b.length === 0) return a.length;
  
    var matrix = [];
  
    // increment along the first column of each row
    var i;
    for (i = 0; i <= b.length; i++) {
      matrix[i] = [i];
    }
  
    // increment each column in the first row
    var j;
    for (j = 0; j <= a.length; j++) {
      matrix[0][j] = j;
    }
  
    // Fill in the rest of the matrix
    for (i = 1; i <= b.length; i++) {
      for (j = 1; j <= a.length; j++) {
        if (b.charAt(i-1) == a.charAt(j-1)) {
          matrix[i][j] = matrix[i-1][j-1];
        } else {
          matrix[i][j] = Math.min(matrix[i-1][j-1] + 1, // substitution
                                  Math.min(matrix[i][j-1] + 1, // insertion
                                           matrix[i-1][j] + 1)); // deletion
        }
      }
    }

    return matrix[b.length][a.length];
  };

  function getClosestTerm(searchPhrase, topicsList) {
    let closetResults = topicsList.reduce((a,b) => {
      return getEditDistance(a.toUpperCase(), searchPhrase.toUpperCase())/a.length <= getEditDistance(b.toUpperCase(), searchPhrase.toUpperCase())/a.length ? a : b;
    })
    return closetResults;
  }

  function getFilteredTopicsList(searchPhrase, topicsList) {
    // Making a case insensitive regular expression
    var regex = new RegExp(`${searchPhrase.trim()}`, 'i');

    let filteredTopicsList = topicsList.filter((item) => {
      return item.search(regex) >= 0;
    });

    return filteredTopicsList.sort((a,b) => { return a.search(regex) - b.search(regex);}); 
  }

  searchText = (phrase) => {
    console.log("=============== SEARCHING LIST ===============");
    let topicsList = props.data

    let filteredTopicsList = getFilteredTopicsList(phrase, topicsList);

    if (!phrase || phrase === '') {
      setFilteredTopicsList(topicsList);
      setNoData(false);
    }

    else if (!filteredTopicsList.length) {
      if (phrase.trim().length <= 18) {
        let closestTerm = getClosestTerm(phrase,topicsList);
        console.log(closestTerm);
        let filteredTopicsListUsingClosestTerm = getFilteredTopicsList(closestTerm, topicsList);
        setFilteredTopicsList(filteredTopicsListUsingClosestTerm);
        setNoData(false);
      } else {
        setFilteredTopicsList([]);
        setNoData(true);
      }
    }
    
    else if (Array.isArray(filteredTopicsList)) {
      setFilteredTopicsList(filteredTopicsList);
      setNoData(false);
    }
  }

  useEffect(() => {
    searchText(props.searchPhrase);
  }, [props.searchPhrase]);

  const renderItem = ({ item }) => {
    return (
      <Pressable style={styles.topicPressable} onPress={() => { props.setSelectedTopic(item); props.setSearchPhrase(item); }} android_ripple={{borderless: false}}>
        <Item name={item} />
      </Pressable>
    );
  };

  return (
    <SafeAreaView style={styles.list__container}>
      <View
        onStartShouldSetResponder={() => {
          props.setClicked(false);
        }}
      >
      {noData ? (
        <Text style={{fontSize:16, alignSelf: "center", paddingTop: 5}}>No Popular Topics Found</Text>
      ) : (
        <FlatList
          data={filteredTopicsList}
          renderItem={renderItem}
          keyExtractor={(item) => item}
          keyboardShouldPersistTaps={"handled"}
        />
      )}
      </View>
    </SafeAreaView>
  );
};

export default TopicNameList;

const styles = StyleSheet.create({
  list__container: {
    flex: 1,
    width: "100%"
  },
  item: {
    marginLeft: 30,
    marginBottom: 10,
    marginTop: 10,
    marginRight: 30,
  },
  title: {
    fontSize: 18,
    marginBottom: 5,
  },
	topicPressable: {
		flexDirection: "row",
    width: "100%",
    alignItems: "center",
		justifyContent: "space-between"
	},
});
