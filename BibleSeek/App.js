/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

 import React, { useEffect, useState} from 'react';
 import type {Node} from 'react';
 
 import SearchScreen from './app/screens/Search';
 import HomeScreen from './app/screens/Home';
 
 import SplashScreen from 'react-native-splash-screen';
 import { NavigationContainer } from '@react-navigation/native';
 import { createNativeStackNavigator } from '@react-navigation/native-stack'; 
 
 import {
   SafeAreaView,
   ScrollView,
   StatusBar,
   Dimensions,
   StyleSheet,
   Text,
   useColorScheme,
   View,
 } from 'react-native';
 
 import {
   Colors,
   DebugInstructions,
   Header,
   LearnMoreLinks,
   ReloadInstructions,
 } from 'react-native/Libraries/NewAppScreen';
 

 const RootStack = createNativeStackNavigator();
 const window = Dimensions.get("window");
 const screen = Dimensions.get("screen");
 
 const App: () => Node = () => {
   const isDarkMode = useColorScheme() === 'dark';
 
   const backgroundStyle = {
     backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
   };

   const [dimensions, setDimensions] = useState({ window, screen });
 
   useEffect(() => {
     SplashScreen.hide();
      const subscription = Dimensions.addEventListener(
        "change",
        ({ window, screen }) => {
          setDimensions({ window, screen });
        }
      );
      return () => subscription?.remove();
   }, [])
 
   return (
     <NavigationContainer>
         <StatusBar
          //  barStyle={isDarkMode ? 'light-content' : 'dark-content'}
          //  backgroundColor={backgroundStyle.backgroundColor}
          barStyle='light-content'
          backgroundColor={global.blue}
           />

         <RootStack.Navigator initialRouteName="Home" screenOptions={{ headerShown: false,}}>
          <RootStack.Screen name="Home" component={HomeScreen}/>
          <RootStack.Screen name="Search" component={SearchScreen}/>
          {/* <RootStack.Screen name="SearchResults"/> */}
         </RootStack.Navigator>
     </NavigationContainer>
   );
 };
 
 export default App;
   