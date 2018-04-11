using UnityEngine;
using System.Collections;

public class piece : MonoBehaviour
{
    public int[] values;
    public float speed;
    float realRotation;

    public KnowTheWayManager ktwm;

    private void Start()
    {
        ktwm = GameObject.FindGameObjectWithTag("GameController").GetComponent<KnowTheWayManager>();
    }

    void Update()
    {
        if (transform.root.rotation.eulerAngles.y != realRotation)
        {
            transform.rotation = Quaternion.Lerp(transform.rotation, Quaternion.Euler(0, realRotation, 0), speed);
        }
    }



    void OnMouseDown()
    {
        int difference = -ktwm.QuickSweep((int)transform.position.x, (int)transform.position.z);

        RotatePiece();

        difference += ktwm.QuickSweep((int)transform.position.x, (int)transform.position.z);
        ktwm.knowTheWayPuzzle.curValue += difference;

        if (ktwm.knowTheWayPuzzle.curValue == ktwm.knowTheWayPuzzle.winValue)
            ktwm.Win();
    }

    public void RotatePiece()
    {
        realRotation += -90; //try plus or minus

        if (realRotation == -360)
            realRotation = 0;

        RotateValues(); 
    }



    public void RotateValues()
    {

        int aux = values[0];

        for (int i = 0; i < values.Length - 1; i++)
        {
            values[i] = values[i + 1];
        }
        values[3] = aux;
    }
}
