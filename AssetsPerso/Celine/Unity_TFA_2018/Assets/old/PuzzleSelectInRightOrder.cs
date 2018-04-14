using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PuzzleSelectInRightOrder : MonoBehaviour
{
    public KeyCode Activate;

    private Animator StoneAnimator;

    private void Start()
    {
        StoneAnimator = GetComponent<Animator>();
    }

    private void OnTriggerStay(Collider other)
    {

        if (other.gameObject.layer == LayerMask.NameToLayer("Player") && Input.GetKeyUp(Activate) == true)
        {
            StoneAnimator.SetTrigger("GoDown");
            for (int i = 0; i < PuzzleSwapRightOrder.PlayerArray.Length; i++)
            {
                PuzzleSwapRightOrder.PlayerArray[i] = GetComponent<Renderer>().material;
                Debug.Log(i);
            }
                
        }

    }
}
