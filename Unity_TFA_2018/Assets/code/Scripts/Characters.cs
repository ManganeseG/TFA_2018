using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Players : MonoBehaviour
{
    private float horizontalMove;
    private float verticalMove;

    public float Speed = 5f;

    public enum WhichCharacter
    {
        Erwin,
        Arjuna,
        Tanvir,
        Mallika
    }
    public WhichCharacter SelectedCharacter = WhichCharacter.Erwin;


    void Start()
    {

    }

    void Update()
    {
        move();
    }

    private void move()
    {
        horizontalMove = Input.GetAxis("Horizontal");
        verticalMove = Input.GetAxis("Vertical");
        
        if(horizontalMove > 0f)
        {

        }
        if(verticalMove > 0f)
        {

        }
    }

    private void modifyCharacter()
    {

    }
}
