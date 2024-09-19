// TopicResultsList.js
import React, {useState, useRef, useEffect} from 'react';
import {useNavigation} from '@react-navigation/native';
import {
  StyleSheet,
  Text,
  View,
  FlatList,
  SafeAreaView,
  ActivityIndicator,
  Animated,
} from 'react-native';
import MaterialCommunityIcons from 'react-native-vector-icons/MaterialCommunityIcons';
import ScriptureCard from './ScriptureCard';
import SearchBar from './SearchBar';

const Item = ({verseData, topic}) => (
  <ScriptureCard style={styles.scriptureCard} data={verseData} topic={topic} />
);

const TopicResultsList = props => {
  const navigation = useNavigation();
  const topic = props.topicSelected;
  const [topicResults, setResults] = useState();
  const [versesCount, setVersesCount] = useState(0);
  const t_kjv = require('../assets/lib/t_kjv.json');
  const bible_key = require('../assets/lib/bible_key_english.json');
  const jsonBible = t_kjv.resultset.row;
  const bibleKey = bible_key.resultset.keys;
  const fadeAnim = useRef(new Animated.Value(0)).current;

  // get data from the fake api
  useEffect(() => {
    const getData = async () => {
      const apiResponse = await fetch(
        'https://bibleseek-3ade5-default-rtdb.firebaseio.com/topics/' +
          topic +
          '.json',
      );
      const data = await apiResponse.json();
      setResults(data);
      setVersesCount(data.length);
    };
    getData();
    Animated.timing(fadeAnim, {
      toValue: 1,
      duration: 1250,
      useNativeDriver: true,
    }).start();
  }, [fadeAnim]);

  function getVerses(startVerseId, endVerseId) {
    let verseString = '';
    for (var i = 0; i < jsonBible.length; i++) {
      let el = jsonBible[i];
      if (el.field[0] >= startVerseId) {
        verseString += el.field[4];
        if (!endVerseId || el.field[0] > endVerseId) break;
        verseString += ' ';
      }
    }
    return verseString;
  }

  function getVerseLocation(startVerseId, endVerseId) {
    let book = bibleKey[parseInt(startVerseId.toString().slice(0, 2)) - 1].n;
    let startChapter = startVerseId.toString().slice(2, 5).replaceAll('0', '');
    let startVerse = startVerseId.toString().slice(5).replaceAll('0', '');

    let verseLocation = book + ' ' + startChapter + ':' + startVerse;

    if (endVerseId) {
      let endVerse = endVerseId.toString().slice(5).replaceAll('0', '');
      verseLocation += '-' + endVerse;
    }

    return verseLocation;
  }

  const renderItem = ({item, topic}) => {
    // item.endVerseId
    // item.startVerseId
    item.verseLocation = getVerseLocation(item.startVerseId, item.endVerseId);
    item.verse = getVerses(item.startVerseId, item.endVerseId);
    return (
      // <Pressable style={styles.topicPressable} onPress={() => { navigation.navigate('TopicResult', item)}}  android_ripple={{borderless: false}}>
      <Item verseData={item} topic={topic} />
      // </Pressable>
    );
  };

  return (
    <SafeAreaView style={styles.root}>
      {!topicResults ? (
        <ActivityIndicator style={styles.activityIndicator} size="large" />
      ) : (
        <Animated.FlatList
          data={topicResults}
          renderItem={renderItem}
          keyExtractor={(item, index) => item.startVerseId + item.endVerseId}
          style={{opacity: fadeAnim}}
        />
      )}
    </SafeAreaView>
  );
};

export default TopicResultsList;

const styles = StyleSheet.create({
  root: {
    flex: 1,
    alignItems: 'center',
    backgroundColor: global.offwhite,
  },
  centeredView: {
    flex: 1,
    justifyContent: 'cetner',
    alignItems: 'center',
  },
  topBar: {
    paddingLeft: 25,
    paddingRight: 25,
    flexDirection: 'row',
    width: '100%',
    borderBottomColor: '#9da29f',
    borderBottomWidth: 1,
    alignItems: 'center',
  },
  header: {
    fontSize: 18,
    marginLeft: 10,
    width: '90%',
    flexWrap: 'wrap',
  },
  bold: {
    fontWeight: 'bold',
  },
  activityIndicator: {
    transform: [{scaleX: 1.3}, {scaleY: 1.3}],
    height: '100%',
    alignSelf: 'center',
    flexDirection: 'row',
  },
});
