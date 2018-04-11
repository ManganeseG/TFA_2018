using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class KnowTheWayManager : MonoBehaviour
{
    public bool GenerateRandom;
    public GameObject[] piecesPrefabs;

    [System.Serializable]
    public class KnowTheWayPuzzle
    {
        public int winValue;
        public int curValue;

        public int width;
        public int height;
        public piece[,] pieces;

    }
    public KnowTheWayPuzzle knowTheWayPuzzle;




    void Start()
    {
        if (GenerateRandom)
        {
            if (knowTheWayPuzzle.width == 0 || knowTheWayPuzzle.height == 0)
            {
                Debug.LogError("Please set the dimensions");
            }
            GeneratePuzzle();
        }
        else
        {
            Vector2 dimensions = CheckDimensions();

            knowTheWayPuzzle.width = (int)dimensions.x;
            knowTheWayPuzzle.height = (int)dimensions.y;


            knowTheWayPuzzle.pieces = new piece[knowTheWayPuzzle.width, knowTheWayPuzzle.height];

            foreach (var piece in GameObject.FindGameObjectsWithTag("KnowTheWayPieces"))
            {

                knowTheWayPuzzle.pieces[(int)piece.transform.position.x, (int)piece.transform.position.z] = piece.GetComponent<piece>(); //replace z here by y

            }
           
        }

        knowTheWayPuzzle.winValue = GetWinValue();
        Shuffle();
        knowTheWayPuzzle.curValue = Sweep();
    }

    int GetWinValue()
    {
        int winValue = 0;
        foreach (var piece in knowTheWayPuzzle.pieces)
        {


            foreach (var j in piece.values)
            {
                winValue += j;
            }
        }
        winValue /= 2;

        return winValue;
    }


    public int Sweep()
    {
        int value = 0;

        for (int h = 0; h < knowTheWayPuzzle.height; h++)
        {
            for (int w = 0; w < knowTheWayPuzzle.width; w++)
            {
                //compares top
                if (h != knowTheWayPuzzle.height - 1)
                    if (knowTheWayPuzzle.pieces[w, h].values[0] == 1 && knowTheWayPuzzle.pieces[w, h + 1].values[2] == 1)
                        value++;
                //compare right
                if (w != knowTheWayPuzzle.width - 1)
                    if (knowTheWayPuzzle.pieces[w, h].values[1] == 1 && knowTheWayPuzzle.pieces[w + 1, h].values[3] == 1)
                        value++;
            }
        }
        return value;
    }

    public int QuickSweep(int w, int h)
    {
        int value = 0;
        //compares top
        if (h != knowTheWayPuzzle.height - 1)
            if (knowTheWayPuzzle.pieces[w, h].values[0] == 1 && knowTheWayPuzzle.pieces[w, h + 1].values[2] == 1)
                value++;
        //compare right
        if (w != knowTheWayPuzzle.width - 1)
            if (knowTheWayPuzzle.pieces[w, h].values[1] == 1 && knowTheWayPuzzle.pieces[w + 1, h].values[3] == 1)
                value++;
        //compare left
        if (w != 0)
            if (knowTheWayPuzzle.pieces[w, h].values[3] == 1 && knowTheWayPuzzle.pieces[w - 1, h].values[1] == 1)
                value++;
        //compare bottom
        if (h != 0)
            if (knowTheWayPuzzle.pieces[w, h].values[2] == 1 && knowTheWayPuzzle.pieces[w, h - 1].values[0] == 1)
                value++;
        return value;
    }

    void Shuffle()
    {
        foreach (var piece in knowTheWayPuzzle.pieces)
        {
            int k = Random.Range(0, 4);

            for (int i = 0; i < k; i++)
            {
                piece.RotatePiece();
            }
        }
    }

    Vector2 CheckDimensions()
    {
        Vector2 aux = Vector2.zero;
        GameObject[] pieces = GameObject.FindGameObjectsWithTag("KnowTheWayPieces");

        foreach (var p in pieces)
        {
            if (p.transform.position.x > aux.x)
                aux.x = p.transform.position.x;

            if (p.transform.position.z > aux.y) //replace z by y
                aux.y = p.transform.position.z; //here too
        }
        aux.x++;
        aux.y++;

        return aux;
    }

    void GeneratePuzzle()
    {
        knowTheWayPuzzle.pieces = new piece[knowTheWayPuzzle.width, knowTheWayPuzzle.height];

        int[] auxValues = { 0, 0, 0, 0 };

        for (int h = 0; h < knowTheWayPuzzle.height; h++)
        {
            for (int w = 0; w < knowTheWayPuzzle.width; w++)
            {
                //width restrictions
                if (w == 0)
                    auxValues[3] = 0;
                else
                    auxValues[3] = knowTheWayPuzzle.pieces[w - 1, h].values[1];

                if (w == knowTheWayPuzzle.width - 1)
                    auxValues[1] = 0;
                else
                    auxValues[1] = Random.Range(0, 2);

                //heigth resctrictions
                if (h == 0)
                    auxValues[2] = 0;
                else
                    auxValues[2] = knowTheWayPuzzle.pieces[w, h - 1].values[0];

                if (h == knowTheWayPuzzle.height - 1)
                    auxValues[0] = 0;
                else
                    auxValues[0] = Random.Range(0, 2);

                //tells piece type
                int valueSum = auxValues[0] + auxValues[1] + auxValues[2] + auxValues[3];

                if (valueSum == 2 && auxValues[0] != auxValues[2])
                    valueSum = 5;

                GameObject go = (GameObject)Instantiate(piecesPrefabs[valueSum], new Vector3(w, 0, h), Quaternion.identity);

                while (go.GetComponent<piece>().values[0] != auxValues[0] ||
                      go.GetComponent<piece>().values[1] != auxValues[1] ||
                      go.GetComponent<piece>().values[2] != auxValues[2] ||
                      go.GetComponent<piece>().values[3] != auxValues[3])

                {
                    go.GetComponent<piece>().RotatePiece();
                }
                knowTheWayPuzzle.pieces[w, h] = go.GetComponent<piece>();
            }
        }



    }

    public void Win()
    {
        //whatToDoIfItsWin
        Debug.Log("It's a win!");
    }
}
