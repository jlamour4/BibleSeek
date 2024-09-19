import React from 'react';
import {StyleSheet, View, Text, Pressable, SafeAreaView} from 'react-native';
import MaterialCommunityIcons from 'react-native-vector-icons/MaterialCommunityIcons';
import {useNavigation} from '@react-navigation/native';

const ScriptureCard = props => {
  const navigation = useNavigation();
  const votes = props.data.votes;
  const verse = props.data.verse;
  const verseLocation = props.data.verseLocation;

  voteFunction((topic, verseItem, voteValue) => {
    verseId = verseItem.startVerseId + verseItem.endVerseId;

    let formdata = new FormData();

    formdata.append('word', topic);
    formdata.append('db', 'dy');
    formdata.append('id', 'vote_' + voteValue + '_' + verseId);
    fetch('https://www.openbible.info/topics/tools/vote?w=' + topic, {
      method: 'POST',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
      body: formdata,
    })
      .then(response => {
        console.log('Vote successful');
      })
      .catch(err => {
        console.log(err);
      });
  });

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.cardHeader}>
        <Text style={styles.verseLocation}>{verseLocation}</Text>
        <MaterialCommunityIcons
          name="dots-vertical"
          color="black"
          size={25}
          style={{padding: 1}}
          onPress={() => {
            alert('MORE');
          }}
        />
      </View>
      <View style={styles.cardBody}>
        <Text numberOfLines={7} textBreakStrategy="highQuality">
          {verse}
        </Text>
      </View>
      <View style={styles.cardFooter}>
        <View style={{flexDirection: 'row', alignItems: 'center'}}>
          <View style={styles.upvoteContainer}>
            <Pressable
              style={styles.upvoteButton}
              onPress={() => {
                alert('up');
              }}
              android_ripple={{color: 'grey', borderless: true}}>
              <MaterialCommunityIcons
                name="thumb-up-outline"
                color={global.grey}
                size={25}
              />
              <Text>{votes}</Text>
            </Pressable>
          </View>

          <View style={styles.downvoteContainer}>
            <Pressable
              style={styles.downvoteButton}
              onPress={() => {
                alert('down');
              }}
              android_ripple={{color: 'grey', borderless: true}}>
              <MaterialCommunityIcons
                name="thumb-down-outline"
                color={global.grey}
                size={25}
              />
            </Pressable>
          </View>
        </View>
        <Text style={{fontSize: 16, opacity: 0.75}}>
          {votes} helpful {votes == 1 ? 'vote' : 'votes'}
        </Text>
        <MaterialCommunityIcons
          name="heart"
          color={global.grey}
          size={25}
          style={{padding: 1}}
          onPress={() => {
            alert('love!');
          }}
        />
      </View>
    </SafeAreaView>
  );
};

export default ScriptureCard;

const styles = StyleSheet.create({
  container: {
    marginTop: 5,
    marginBottom: 5,
    backgroundColor: 'white',
    padding: 10,
    width: '100%',
  },
  cardHeader: {
    justifyContent: 'space-between',
    flexDirection: 'row',
  },
  verseLocation: {
    fontWeight: 'bold',
    fontSize: 18,
    color: global.darkGrey,
  },
  cardBody: {
    marginBottom: 20,
  },
  cardFooter: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  flexRow: {
    flexDirection: 'row',
    alignContent: 'center',
  },
  input: {
    fontSize: 18,
    marginLeft: 10,
    width: '90%',
    flexWrap: 'nowrap',
  },
  upvoteContainer: {
    alignSelf: 'center',
    backgroundColor: global.offwhite,
    borderBottomLeftRadius: 20,
    borderTopLeftRadius: 20,
    borderRightWidth: 1,
    borderRightColor: global.white,
    overflow: 'hidden',
  },
  downvoteContainer: {
    alignSelf: 'center',
    backgroundColor: global.offwhite,
    borderBottomRightRadius: 20,
    borderTopRightRadius: 20,
    borderLeftWidth: 1,
    borderLeftColor: global.white,
    overflow: 'hidden',
  },
  upvoteButton: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 10,
  },
  downvoteButton: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 10,
  },
});
