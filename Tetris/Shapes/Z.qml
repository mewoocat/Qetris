import "../"

Shape {
    style: BlockStyle {
        color: "darkgreen"
        borderColor: "limegreen"
    }
    orientations: [
        [
            {x: 0, y: 1},
            {x: 1, y: 1},
            {x: 1, y: 2},
            {x: 2, y: 2},
        ],
        [
            {x: 1, y: 0},
            {x: 0, y: 1},
            {x: 1, y: 1},
            {x: 0, y: 2},
        ],
    ]
}
