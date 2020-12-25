# Hand dataset convert MAT file to XML file (VOC format)

## VGG Hands dataset
The number of big hand: 6813  
The number of Image: 3942 
The number of skip: 1686  
```
Your path + hand_dataset  (here need put on convert code)
├─test_dataset  
│  └─test_data  
│      ├─annotations  
│      └─images  
├─training_dataset  
│  └─training_data  
│      ├─annotations  
│      └─images  
└─validation_dataset  
    └─validation_data  
        ├─annotations  
        └─images  
```

## Ego Hands dataset
The number of hand: 15053  
The number of Image: 4787  
The number of skip: 13  
```
your path + egohands_data  (here need put on convert code)
└─_LABELLED_SAMPLES
    ├─CARDS_COURTYARD_B_T
    ├─CARDS_COURTYARD_H_S
    
        \\\ skip ///
    
    ├─PUZZLE_OFFICE_S_T
    └─PUZZLE_OFFICE_T_S
    
Total 48 folder
```


## Dataset source
* [VGG Hand Dataset](https://www.robots.ox.ac.uk/~vgg/data/hands/)
* [EgoHands Dataset](http://vision.soic.indiana.edu/projects/egohands/)
