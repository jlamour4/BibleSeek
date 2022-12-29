// import React from "react";
// import { StyleSheet, TextInput, View, Keyboard, Button } from "react-native";
// import MaterialCommunityIcons from 'react-native-vector-icons/MaterialCommunityIcons';
// import { Icon } from 'react-native-elements';


// const UserSettings = (props) => {
//   return (
//     <View style={styles.container}>
//       <View
//         style={
//           !props.clicked
//             ? styles.searchBar__unclicked
//             : styles.searchBar__clicked
//         }
//       >
//         <MaterialCommunityIcons name="magnify" color="black" size={20} style={{padding:1}} />
//         <TextInput
//           style={styles.input}
//           placeholder="Search for topics & keywords"
//           value={props.searchPhrase}
//           onChangeText={props.setSearchPhrase}
//           onFocus={() => {
//             props.setClicked(true);
//           }}
//         />
        
//         {props.clicked && (
//           <MaterialCommunityIcons name="close" color="black" size={20} style={{padding:1}} onPress={() => {
//             props.setSearchPhrase("")
//           }}/>

//         )}
//       </View>
//       {props.clicked && (
//         <View>
//           <Button
//             title="Cancel"
//             onPress={() => {
//               Keyboard.dismiss();
//               props.setClicked(false);
//             }}
//           ></Button>
//         </View>
//       )}
//     </View>
//   );
// };

// export default UserSettings;

// const styles = StyleSheet.create({
//   container: {
//     margin: 15,
//     justifyContent: "flex-start",
//     alignItems: "center",
//     flexDirection: "row",
//     width: "90%",
    
//   },
//   searchBar__unclicked: {
//     padding: 5,
//     flexDirection: "row",
//     width: "100%",
//     backgroundColor: "#d9dbda",
//     borderRadius: 35,
//     alignItems: "center",
//   },
//   searchBar__clicked: {
//     padding: 10,
//     flexDirection: "row",
//     width: "80%",
//     backgroundColor: "#d9dbda",
//     borderRadius: 15,
//     alignItems: "center",
//     justifyContent: "space-evenly",
//   },
//   input: {
//     fontSize: 18,
//     marginLeft: 10,
//     width: "90%",
//     flexWrap: "nowrap",
//   },
// });
