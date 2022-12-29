import { useNavigation } from "@react-navigation/native";
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

// the filter
const TopicNameList = (props) => {

  const navigation = useNavigation();
  const [filteredTopicsList, setFilteredTopicsList] = useState(props.searchPhrase);
  const [noData, setNoData] = useState(true);

  searchText = (phrase) => {
    console.log("=============== SEARCHING LIST ===============");
    let text = phrase.toUpperCase()
    let currentTopicsList = props.data
    let filteredTopicsList = currentTopicsList.filter((item) => {
      return item.toUpperCase().match(text)
    })
    if (!text || text === '') {
      setFilteredTopicsList(currentTopicsList);
      setNoData(false);
    } else if (!Array.isArray(filteredTopicsList) && !filteredTopicsList.length) {
      // set no data flag to true so as to render flatlist conditionally
      setNoData(true);
    } else if (Array.isArray(filteredTopicsList)) {
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
        <Text>Nothing Found</Text>
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
    height: "auto",
    width: "100%",
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
