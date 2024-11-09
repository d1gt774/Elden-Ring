#!/bin/bash

# Introduction and Class Selection
echo "Welcome Tarnished. Please select your starting class:"
echo "1 - Samurai"
echo "2 - Prisoner"
echo "3 - Prophet"
echo "Choose a class by typing the corresponding number:"
read class

case $class in
    1) class_name="Samurai"
       health=100
       attack=15
       level=1
       ;;
    2) class_name="Prisoner"
       health=80
       attack=20
       level=1
       ;;
    3) class_name="Prophet"
       health=90
       attack=12
       level=1
       ;;
    *) echo "Invalid selection. Exiting game." 
       exit 1
       ;;
esac

echo "You have chosen the $class_name class. Your starting health is $health and attack power is $attack."

# Inventory
inventory=("Health Potion")
inventory_count=(1)  # Start with one health potion

# First Beast Battle
echo -e "\nA wild beast approaches! Get ready for your first battle."
beast1_health=$((RANDOM % 30 + 40))  # Random health for beast
beast1_attack=$((RANDOM % 10 + 5))   # Random attack for beast
echo "Beast health: $beast1_health | Beast attack: $beast1_attack"

while [ $health -gt 0 ] && [ $beast1_health -gt 0 ]; do
    echo -e "\nPick a number between 1-10 to strike the beast or type 'use potion' to use a health potion: "
    read tarnished_attack

    if [[ $tarnished_attack == "use potion" && ${inventory_count[0]} -gt 0 ]]; then
        echo "You use a health potion and restore 20 health!"
        health=$((health + 20))
        inventory_count[0]=$((inventory_count[0] - 1))
        echo "Remaining health: $health"
    elif [[ $tarnished_attack -gt 0 && $tarnished_attack -le 10 ]]; then
        damage=$((RANDOM % attack + 1))
        echo "You strike the beast and deal $damage damage!"
        beast1_health=$((beast1_health - damage))

        if [ $beast1_health -le 0 ]; then
            echo "Beast VANQUISHED! Congrats, fellow Tarnished!"
            level=$((level + 1))
            attack=$((attack + 2))  # Increase attack on level up
            health=$((health + 10))  # Increase health on level up
            break
        fi

        echo "The beast retaliates and deals $beast1_attack damage to you!"
        health=$((health - beast1_attack))

        if [ $health -le 0 ]; then
            echo "You Died in battle."
            exit 1
        fi
    else
        echo "Invalid input. You missed your chance to strike!"
    fi
done

sleep 1

# Boss Battle with Margit
echo -e "\nBoss Battle: Get ready for Margit the Fell. Pick a number between 0-9 to fight back!"
margit_health=$((RANDOM % 50 + 60))  # Random health for Margit
margit_attack=$((RANDOM % 15 + 10))  # Random attack for Margit
echo "Margit's health: $margit_health | Margit's attack: $margit_attack"

while [ $health -gt 0 ] && [ $margit_health -gt 0 ]; do
    read tarnished
    if [[ $tarnished =~ ^[0-9]$ && $tarnished -ge 0 && $tarnished -le 9 ]]; then
        damage=$((RANDOM % attack + 1))
        echo "You strike Margit and deal $damage damage!"
        margit_health=$((margit_health - damage))

        if [ $margit_health -le 0 ]; then
            echo "Margit VANQUISHED! You have defeated the boss!"
            level=$((level + 1))
            attack=$((attack + 3))  # Increase attack on level up
            health=$((health + 15))  # Increase health on level up
            break
        fi

        echo "Margit retaliates and deals $margit_attack damage to you!"
        health=$((health - margit_attack))

        if [ $health -le 0 ]; then
            echo "You Died in the battle with Margit."
            exit 1
        fi
    else
        echo "Invalid input. Margit strikes you while you hesitate!"
        health=$((health - margit_attack))
    fi
done

# Second Boss Battle: Optional Path
echo -e "\nWould you like to venture further and face another boss? (yes/no)"
read choice

if [[ $choice == "yes" ]]; then
    echo -e "\nYou venture further and encounter a new foe, the Knight of Ash!"
    knight_health=$((RANDOM % 60 + 80))
    knight_attack=$((RANDOM % 20 + 15))
    echo "Knight of Ash's health: $knight_health | Knight of Ash's attack: $knight_attack"

    while [ $health -gt 0 ] && [ $knight_health -gt 0 ]; do
        read tarnished
        if [[ $tarnished =~ ^[0-9]$ && $tarnished -ge 0 && $tarnished -le 9 ]]; then
            damage=$((RANDOM % attack + 1))
            echo "You strike the Knight of Ash and deal $damage damage!"
            knight_health=$((knight_health - damage))

            if [ $knight_health -le 0 ]; then
                echo "Knight of Ash VANQUISHED! You have claimed another victory!"
                level=$((level + 1))
                attack=$((attack + 4))  # Increase attack on level up
                health=$((health + 20))  # Increase health on level up
                break
            fi

            echo "The Knight retaliates and deals $knight_attack damage to you!"
            health=$((health - knight_attack))

            if [ $health -le 0 ]; then
                echo "You Died in the battle with the Knight of Ash."
                exit 1
            fi
        else
            echo "Invalid input. The Knight strikes you while you hesitate!"
            health=$((health - knight_attack))
        fi
    done
fi

# End of Game
echo -e "\nGame Over. Your final stats: Level $level, Health $health, Attack $attack."
if [ $health -gt 0 ]; then
    echo "Congratulations, Tarnished! You have conquered the trials!"
else
    echo "Better luck next time, Tarnished."
fi

