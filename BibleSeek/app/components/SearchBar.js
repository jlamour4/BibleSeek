import React, { useEffect } from "react";
import { StyleSheet, TextInput, View } from "react-native";
import MaterialCommunityIcons from 'react-native-vector-icons/MaterialCommunityIcons';
import { useNavigation } from "@react-navigation/native";



const SearchBar = (props) => {
  const navigation = useNavigation();

  useEffect(()=> {
    myInput.blur();
  }, [props.topicSelected])

  return (
    <View style={styles.container}>
      <View
        style={styles.searchBar__clicked}
      > 
        <MaterialCommunityIcons name="arrow-left" color="black" size={25} style={{padding:1}} onPress={() => {navigation.goBack()}}/>
        <TextInput
          style={styles.input}
          placeholder="Search for topics & keywords"
          value={props.searchPhrase}
          onChangeText={props.setSearchPhrase}
          autoFocus={true}
          autoCapitalize={'none'}
          ref={(ref) => { myInput = ref }}
          onFocus={() => {
            props.setClicked(true);
          }}
          onSubmitEditing={() => {props.setSelectedTopic(props.searchPhrase)}}
        />
        
        {props.searchPhrase ? <MaterialCommunityIcons name="close" color="black" size={25} style={{padding:1}} onPress={() => { props.setSearchPhrase(""); props.setSelectedTopic("") }}/>
          : <View>
              <MaterialCommunityIcons name="microphone-outline" color="black" size={25} style={{padding:1}} onPress={() => { alert("VOICE SEARCH"); }}/>
            </View>}

      </View>
    </View>
  );
};

export default SearchBar;

const styles = StyleSheet.create({
  container: {
    marginHorizontal: 5,
    // justifyContent: "flex-start",
    // alignItems: "center",
    // flexDirection: "row",
    // width: "90%",
  },
  searchBar__clicked: {
    backgroundColor: "white",
    paddingLeft: 25,
    paddingRight: 25,
    flexDirection: "row",
    width: "100%",
    borderBottomColor: "#9da29f",
    borderBottomWidth: 1,
    alignItems: "center",
  },
  
  input: {
    fontSize: 18,
    marginLeft: 10,
    width: "90%",
    flexWrap: "nowrap"
  },
});
