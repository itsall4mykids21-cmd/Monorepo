export const games = [
  { name: 'Lucky Cherry', image: require('./images/lucky-cherry.png') },
  { name: 'Golden Lemon', image: require('./images/golden-lemon.png') },
  { name: 'Bell Star', image: require('./images/bell-star.png') },
  { name: 'Emerald Clover', image: require('./images/emerald-clover.png') },
  { name: 'Diamond Spin', image: require('./images/diamond-spin.png') },
  { name: 'Super Seven', image: require('./images/super-seven.png') },
  { name: 'Mega Bar', image: require('./images/mega-bar.png') },
  { name: 'Jackpot King', image: require('./images/jackpot-king.png') },
  ...Array.from({ length: 92 }, (_, i) => ({
    name: `Game ${i + 9}`,
    image: require('./images/placeholder.png')
  }))
];